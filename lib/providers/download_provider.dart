// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart'
    as rdu;
import 'package:explorer/utils/files_operations_utils/download_utils.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;
import 'package:uuid/uuid.dart';

class DownloadProvider extends ChangeNotifier {
  List<DownloadTaskModel> tasks = [];
  bool downloading = false;
  double? downloadSpeed;

  List<DownloadTaskModel> get activeTasks =>
      [..._downloadingTasks, ...pausedTasks, ..._pendingTasks];

  List<DownloadTaskModel> get doneTasks => [
        ...tasks.where((element) => element.taskStatus == TaskStatus.finished)
      ].reversed.toList();

  List<DownloadTaskModel> get failedTasks => [
        ...tasks.where((element) => element.taskStatus == TaskStatus.failed)
      ].reversed.toList();

  Iterable<DownloadTaskModel> get pausedTasks =>
      tasks.where((element) => element.taskStatus == TaskStatus.paused);
  Iterable<DownloadTaskModel> get _downloadingTasks =>
      tasks.where((element) => element.taskStatus == TaskStatus.downloading);

  Iterable<DownloadTaskModel> get _pendingTasks =>
      tasks.where((element) => element.taskStatus == TaskStatus.pending);

  void clearAllTasks() async {
    tasks.clear();
    notifyListeners();
    File(getSaveFilePath(FileType.video, 'fileName'))
        .parent
        .parent
        .deleteSync(recursive: true);
  }

  void togglePauseResumeTask(
    String taskID,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    int index = tasks.indexWhere((element) => element.id == taskID);
    TaskStatus taskStatus = tasks[index].taskStatus;
    if (taskStatus == TaskStatus.paused) {
      _resumeTaskDownload(
        index,
        serverProvider,
        shareProvider,
      );
    } else if (taskStatus == TaskStatus.downloading) {
      _pauseTaskDownload(index);
    }
  }

  void _pauseTaskDownload(int index) {
    tasks[index].downloadTaskController!.cancelTask();
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = TaskStatus.paused;

    tasks[index] = newTask;
    notifyListeners();
  }

  void _resumeTaskDownload(
    int index,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = TaskStatus.downloading;

    tasks[index] = newTask;
    notifyListeners();
    _startDownloadTask(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      downloadTaskModel: newTask,
    );
  }

  void _setTaskController(
    String taskID,
    rdu.DownloadTaskController downloadTaskController,
  ) {
    int index = tasks.indexWhere((element) => element.id == taskID);
    DownloadTaskModel downloadTaskModel = tasks[index];
    downloadTaskModel.downloadTaskController = downloadTaskController;
    tasks[index] = downloadTaskModel;
    notifyListeners();
  }

  void _updateTaskPercent(String taskID, int count) {
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
    required String remoteDeviceName,
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
        remoteDeviceID: remoteDeviceID,
        remoteDeviceName: remoteDeviceName);
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
      rdu.DownloadTaskController downloadTaskController =
          rdu.DownloadTaskController(
        downloadPath: downloadFolderPath,
        myDeviceID: me.deviceID,
        mySessionID: me.sessionID,
        remoteFilePath: downloadTaskModel.remoteFilePath,
        url: remotePeer.getMyLink(downloadFileEndPoint),
        setProgress: (int received) {
          _updateTaskPercent(downloadTaskModel.id, received);
        },
        setSpeed: (speed) {
          downloadSpeed = speed;
          notifyListeners();
        },
        remoteDeviceID: downloadTaskModel.remoteDeviceID,
        remoteDeviceName: downloadTaskModel.remoteDeviceName,
      );
      _setTaskController(downloadTaskModel.id, downloadTaskController);
      // ignore: unused_local_variable
      var res = await downloadTaskController.downloadFile();

      if (res == 0) {
        // zero return mean that the download isn't finished, paused

        return;
      } else if (res is int && res > 0) {
        // this mean that the file has been paused
        // if the connection has been cut this mean that there was an error and it shouldn't be considered paused, but error task status
        // the task is already downloading from the latest call of _markDownloadTask so this toggle will mark it as paused
        // don't call toggle from here because you are already called it from the button click and this will reverse it's functionality
        _markDownloadTask(
          downloadTaskModel.id,
          TaskStatus.finished,
          serverProvider,
          shareProvider,
        );
      } else {
        throw Exception('Error occurred during download');
      }
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
