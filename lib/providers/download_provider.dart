// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/remote_download_utils.dart' as rdu;
import 'package:explorer/utils/files_operations_utils/download_utils.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;
import 'package:uuid/uuid.dart';

class DownloadProvider extends ChangeNotifier {
  List<DownloadTaskModel> tasks = [];
  bool downloading = false;
  double? downloadSpeed;

  List<DownloadTaskModel> get activeTasks =>
      [..._downloadingTasks, ..._pendingTasks];

  List<DownloadTaskModel> get doneTasks => [
        ...tasks.where((element) => element.taskStatus == TaskStatus.finished)
      ].reversed.toList();

  List<DownloadTaskModel> get failedTasks => [
        ...tasks.where((element) => element.taskStatus == TaskStatus.failed)
      ].reversed.toList();

  Iterable<DownloadTaskModel> get _downloadingTasks =>
      tasks.where((element) => element.taskStatus == TaskStatus.downloading);

  Iterable<DownloadTaskModel> get _pendingTasks =>
      tasks.where((element) => element.taskStatus == TaskStatus.pending);

  void clearAllTasks() {
    tasks.clear();
    notifyListeners();
  }

  void setDownloading(bool i) {
    downloading = i;
    notifyListeners();
  }

  void setDownloadSpeed(double s) {
    downloadSpeed = s;
    notifyListeners();
  }

  void updateTaskPercent(String taskID, int count) {
    int index = tasks.indexWhere((element) => element.id == taskID);
    DownloadTaskModel newTask = tasks[index];
    newTask.count = count;
    tasks[index] = newTask;
    notifyListeners();
  }
  // ! when loading tasks from the sqlite don't load all tasks, just load the tasks that need to be download or whose status isn't finished,
  //! and only load the finished tasks when the user wants to see them

  // to check if there is no tasks in the queue or all the tasks are finished or failed
  bool get tasksFree =>
      tasks.isEmpty ||
      tasks.every(
        (element) =>
            element.taskStatus == TaskStatus.finished ||
            element.taskStatus == TaskStatus.failed,
      );

  // when adding a new download task i want to check if there is any task downloading now or not
  // this will be called when the user wants to download a file from the other device storage
  void addDownloadTask({
    required String remoteFilePath,
    required int? fileSize,
    required String remoteDeviceID,
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
  }) {
    bool tasksFreeLocal = tasksFree;
    DownloadTaskModel downloadTaskModel = DownloadTaskModel(
      id: Uuid().v4(),
      peerDeviceID: remoteDeviceID,
      remoteFilePath: remoteFilePath,
      addedAt: DateTime.now(),
      size: fileSize,
      taskStatus: TaskStatus.pending,
    );
    tasks.add(downloadTaskModel);
    notifyListeners();
    //? this is to start downloading the task if there is no tasks downloading
    if (tasksFreeLocal) {
      _startDownloadTask(
        shareProvider: shareProvider,
        serverProvider: serverProvider,
        downloadTaskModel: downloadTaskModel,
      );
    }
  }

  // after finishing a task from downloading this will check for the next tasks in the queue to start downloading
  void _downloadNextTask({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
  }) {
    if (tasks.any((element) => element.taskStatus == TaskStatus.pending)) {
      _startDownloadTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
        downloadTaskModel: tasks.firstWhere(
          (element) => element.taskStatus == TaskStatus.pending,
        ),
      );
    }
  }

  // this will mark a task with a flag(downloading, finished, etc..)
  void _markDownloadTask(
    String downloadTaskID,
    TaskStatus taskStatus,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    int index = tasks.indexWhere((element) => element.id == downloadTaskID);
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = taskStatus;
    if (taskStatus == TaskStatus.finished) {
      newTask.finishedAt = DateTime.now();
    }
    tasks[index] = newTask;
    notifyListeners();
    if (taskStatus == TaskStatus.finished) {
      _downloadNextTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
      );
    }
  }

  // this will start downloading a task immediately
  Future<void> _startDownloadTask({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
    required DownloadTaskModel downloadTaskModel,
    // String? customDownloadPath,
  }) async {
    try {
      PeerModel me = serverProvider.me(shareProvider);
      PeerModel remotePeer =
          serverProvider.peerModelWithDeviceID(downloadTaskModel.peerDeviceID);

      downloading = true;
      notifyListeners();
      String fileName =
          path_operations.basename(downloadTaskModel.remoteFilePath);
      FileType fileType = getFileTypeFromPath(downloadTaskModel.remoteFilePath);
      String downloadFolderPath = getSaveFilePath(fileType, fileName);

      _markDownloadTask(
        downloadTaskModel.id,
        TaskStatus.downloading,
        serverProvider,
        shareProvider,
      );

      //? new way of downloading with multiple streams for faster downloading speed
      // ignore: unused_local_variable
      int? fileSize = await rdu.chunkedDownloadFile(
        url: remotePeer.getMyLink(downloadFileEndPoint),
        downloadPath: downloadFolderPath,
        setProgress: (int received) {
          updateTaskPercent(downloadTaskModel.id, received);
        },
        setSpeed: (speed) {
          downloadSpeed = speed;
          notifyListeners();
        },
        headers: {
          filePathHeaderKey:
              Uri.encodeComponent(downloadTaskModel.remoteFilePath),
          sessionIDHeaderKey: me.sessionID,
          deviceIDString: me.deviceID,
        },
      );
      if (fileSize == null) {
        throw CustomException(
          e: 'File isn\'t valid',
          s: StackTrace.current,
          rethrowError: true,
        );
      }
      _markDownloadTask(
        downloadTaskModel.id,
        TaskStatus.finished,
        serverProvider,
        shareProvider,
      );

      //? old way of downloading with a single stream
      // await dio.download(
      //   remotePeer.getMyLink(downloadFileEndPoint),
      //   downloadFolderPath,
      //   options: Options(
      //     headers: {
      //       filePathHeaderKey:
      //           Uri.encodeComponent(downloadTaskModel.remoteFilePath),
      //       sessionIDHeaderKey: me.sessionID,
      //       deviceIDString: me.deviceID,
      //     },
      //   ),
      //   onReceiveProgress: (count, total) {
      //     downloadSpeed =
      //         ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000) /
      //             (count / 1021 / 1024);
      //     updateTaskPercent(downloadTaskModel.id, count);

      //     if (count == total) {
      //       downloading = false;
      //       notifyListeners();

      //       // mark the download task as done
      //       _markDownloadTask(
      //         downloadTaskModel.id,
      //         TaskStatus.finished,
      //         serverProvider,
      //         shareProvider,
      //       );
      //     }
      //   },
      // );
    } catch (e, s) {
      _markDownloadTask(
        downloadTaskModel.id,
        TaskStatus.failed,
        serverProvider,
        shareProvider,
      );
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
  }
}
