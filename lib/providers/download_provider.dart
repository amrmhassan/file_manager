// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/files_operations_utils/download_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;
import 'package:uuid/uuid.dart';

class DownloadProvider extends ChangeNotifier {
  List<DownloadTaskModel> tasks = [];
  bool downloading = false;
  double? downloadSpeed;
  double? downloadedPercent;

  void setDownloading(bool i) {
    downloading = i;
    notifyListeners();
  }

  void setDownloadSpeed(double s) {
    downloadSpeed = s;
    notifyListeners();
  }

  void setDownloadPercent(double p) {
    downloadedPercent = p;
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
  void addDownloadTask({
    required String remoteFilePath,
    required int? fileSize,
    required String remoteDeviceID,
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
  }) {
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
    if (tasksFree) {
      _startDownloadTask(
        shareProvider: shareProvider,
        serverProvider: serverProvider,
        downloadTaskModel: downloadTaskModel,
      );
    }
  }

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

  void _markDownloadTask(
    String downloadTaskID,
    TaskStatus taskStatus,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    int index = tasks.indexWhere((element) => element.id == downloadTaskID);
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = taskStatus;
    tasks[index] = newTask;
    notifyListeners();
    if (taskStatus == TaskStatus.finished) {
      _downloadNextTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
      );
    }
  }

  Future<void> _startDownloadTask({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
    required DownloadTaskModel downloadTaskModel,
    // String? customDownloadPath,
  }) async {
    PeerModel me = serverProvider.me(shareProvider);
    PeerModel remotePeer =
        serverProvider.peerModelWithDeviceID(downloadTaskModel.peerDeviceID);
    DateTime before = DateTime.now();
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
    Dio dio = Dio();
    await dio.download(
      remotePeer.getMyLink(downloadFileEndPoint),
      downloadFolderPath,
      deleteOnError: false,
      options: Options(
        headers: {
          filePathHeaderKey:
              Uri.encodeComponent(downloadTaskModel.remoteFilePath),
          sessionIDHeaderKey: me.sessionID,
          deviceIDString: me.deviceID,
        },
      ),
      onReceiveProgress: (count, total) {
        DateTime after = DateTime.now();
        int diff = after.difference(before).inMilliseconds;
        double speed = ((total / 1024 / 1024) / (diff / 1000));
        downloadSpeed = speed;
        downloadedPercent = count / total;
        notifyListeners();
        if (count == total) {
          downloading = false;
          notifyListeners();

          // mark the download task as done
          _markDownloadTask(
            downloadTaskModel.id,
            TaskStatus.finished,
            serverProvider,
            shareProvider,
          );
        }
      },
    );
  }
}
