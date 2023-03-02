// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:explorer/constants/server_constants.dart';

import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart'
    as rdu;
import 'package:explorer/utils/files_operations_utils/download_utils.dart';

//! when loading the download tasks at the download screen startup
//! set a variable loadedFromDb to be true
//! if any download task is paused or downloading set it to be failed
//! failed tasks can be resumed just like the paused tasks, but make sure first you are connected to the device that the download task
//! has his deviceID

class DownloadProvider extends ChangeNotifier {
  List<DownloadTaskModel> tasks = [];
  bool taskLoadedFromDb = false;
  late int maxDownloadsAtAtime;

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

//  fix this function here, after testing it first
  void updateMaxParallelDownloads(
    int n,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) async {
    int previousValue = maxDownloadsAtAtime;
    maxDownloadsAtAtime = n;
    notifyListeners();
    await SharedPrefHelper.setString(maxParallelDownloadsKey, n.toString());
    if (n > previousValue) {
      _pendingTasks.take(n - previousValue).forEach((element) {
        _startDownloadTask(
          serverProvider: serverProvider,
          shareProvider: shareProvider,
          downloadTaskModel: element,
        );
      });
    } else if (n < previousValue) {
      _downloadingTasks.skip(maxDownloadsAtAtime).forEach((element) {
        // togglePauseResumeTask(element.id, serverProvider, shareProvider);
        _markTasksAsPending(element.id);
      });
    }
  }

  Future<void> _markTasksAsPending(String taskID) async {
    int index = tasks.indexWhere((element) => element.id == taskID);
    _pauseTaskDownload(index, pending: true);
  }

  Future<void> loadDownloadSettings() async {
    maxDownloadsAtAtime = int.parse(
        await SharedPrefHelper.getString(maxParallelDownloadsKey) ??
            '$maxParallelDownloadTasksDefault');
  }

  Future<bool> continueFailedTasks(
      DownloadTaskModel downloadTaskModel,
      ServerProvider serverProviderFalse,
      ShareProvider shareProviderFalse) async {
    String deviceID = downloadTaskModel.remoteDeviceID;
    bool connectedToDevice =
        serverProviderFalse.connectedToDeviceWithId(deviceID);
    if (!connectedToDevice) {
      //! i am supposed to throw an error and catch it form the UI but it doesn't work
      // throw CustomException(
      //   e: 'Not connected to the owner of this file',
      //   s: StackTrace.current,
      // );
      return false;
    }
    int index =
        tasks.indexWhere((element) => element.id == downloadTaskModel.id);

    _resumeTaskDownload(index, serverProviderFalse, shareProviderFalse);
    return true;
  }

  Future<void> loadTasks() async {
    if (taskLoadedFromDb) return;
    taskLoadedFromDb = true;
    var box = await HiveBox.downloadTasks;
    List<DownloadTaskModel> loadedTasks = box.values.toList().cast();
    List<DownloadTaskModel> parsedTasks = [];
    for (var loadedTask in loadedTasks) {
      if (loadedTask.taskStatus == TaskStatus.downloading ||
          loadedTask.taskStatus == TaskStatus.paused ||
          loadedTask.taskStatus == TaskStatus.pending) {
        loadedTask.taskStatus = TaskStatus.failed;
      }
      parsedTasks.add(loadedTask);
    }
    tasks = [...parsedTasks];
    notifyListeners();
  }

  Future<void> _removeTaskById(String id) async {
    tasks.removeWhere((element) => element.id == id);
    notifyListeners();
    var box = await HiveBox.downloadTasks;
    await box.delete(id);
  }

  Future<void> deleteTaskCompletely(
    String taskID,
    ServerProvider serverProvider,
    ShareProvider shareProvider, {
    bool alsoFile = false,
  }) async {
    int index = tasks.indexWhere((element) => element.id == taskID);
    if (alsoFile) {
      await rdu.DownloadTaskController.deleteTaskFromStorage(
        tasks[index].localFilePath,
      );
    }
    await _pauseTaskDownload(index);
    await _removeTaskById(taskID);
    _downloadNextTask(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
    );
  }

  Future<void> clearAllTasks(
      ServerProvider serverProvider, ShareProvider shareProvider) async {
    tasks.clear();
    notifyListeners();
    // File(getSaveFilePath(FileType.video, 'fileName'))
    //     .parent
    //     .parent
    //     .deleteSync(recursive: true);
    for (var task in _downloadingTasks) {
      await deleteTaskCompletely(task.id, serverProvider, shareProvider);
    }
    Directory(checkMainDownloadFolder()).deleteSync(recursive: true);
    var box = await HiveBox.downloadTasks;
    await box.clear();
  }

  void togglePauseResumeTask(
    String taskID,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    int index = tasks.indexWhere((element) => element.id == taskID);
    if (tasks[index].taskStatus == TaskStatus.paused) {
      _resumeTaskDownload(
        index,
        serverProvider,
        shareProvider,
      );
    } else if (tasks[index].taskStatus == TaskStatus.downloading) {
      _downloadNextTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
        skipAllow: true,
      );
      _pauseTaskDownload(index);
    }
  }

  Future<void> _pauseTaskDownload(int index, {bool pending = false}) async {
    tasks[index].downloadTaskController?.cancelTask();
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = pending ? TaskStatus.pending : TaskStatus.paused;
    await _updateTask(index, newTask);
  }

  void _resumeTaskDownload(
    int index,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) {
    if (allowDownloadNextTask) {
      DownloadTaskModel newTask = tasks[index];
      newTask.taskStatus = TaskStatus.downloading;

      _updateTask(index, newTask);
      _startDownloadTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
        downloadTaskModel: newTask,
      );
    } else {
      DownloadTaskModel newTask = tasks[index];
      newTask.taskStatus = TaskStatus.pending;

      _updateTask(index, newTask);
    }
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
    //don't save this into the box, to prevent so many db reads, which will slow down the process
    int index = tasks.indexWhere((element) => element.id == taskID);
    DownloadTaskModel newTask = tasks[index];
    newTask.count = count;
    tasks[index] = newTask;
    notifyListeners();
  }
  // ! when loading tasks from the sqlite don't load all tasks, just load the tasks that need to be download or whose status isn't finished,
  //! and only load the finished tasks when the user wants to see them

  //! i am here
  bool get allowDownloadNextTask =>
      tasks
          .where((element) => element.taskStatus == TaskStatus.downloading)
          .length <
      maxDownloadsAtAtime;

  //! add a function to handle running tasks, and start the next one
  // when adding a new download task i want to check if there is any task downloading now or not
  // this will be called when the user wants to download a file from the other device storage
  Future<void> addDownloadTaskFromPeer({
    required String remoteFilePath,
    required int? fileSize,
    required String? remoteDeviceID,
    required String? remoteDeviceName,
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
  }) async {
    DownloadTaskModel? task;

    try {
      task = tasks.firstWhere((element) =>
          element.remoteFilePath == remoteFilePath &&
          element.remoteDeviceID == remoteDeviceID);
    } catch (e) {
      if (task == null) {
        logger
            .i('Task doesn\'t exit and it will be added to be downloaded soon');
      } else {
        throw CustomException(
          e: 'Task already added and ${task.taskStatus.name}',
          s: StackTrace.current,
        );
      }
    }
    // to check if there is no tasks in the queue or all the tasks are finished or failed

    DownloadTaskModel downloadTaskModel = DownloadTaskModel(
      id: Uuid().v4(),
      remoteFilePath: remoteFilePath,
      addedAt: DateTime.now(),
      size: fileSize,
      taskStatus: TaskStatus.pending,
      remoteDeviceID: remoteDeviceID ?? laptopID,
      remoteDeviceName: remoteDeviceName ?? laptopName,
    );
    tasks.add(downloadTaskModel);
    notifyListeners();
    var box = await HiveBox.downloadTasks;
    await box.put(downloadTaskModel.id, downloadTaskModel);

    //? this is to start downloading the task if there is no tasks downloading
    if (allowDownloadNextTask) {
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
    bool skipAllow = false,
  }) {
    if (!allowDownloadNextTask && !skipAllow) return;
    var tasksToDownload =
        tasks.where((element) => element.taskStatus == TaskStatus.pending);
    if (tasksToDownload.isNotEmpty) {
      _startDownloadTask(
        serverProvider: serverProvider,
        shareProvider: shareProvider,
        downloadTaskModel: tasksToDownload.first,
      );
    }
  }

  Future<void> _updateTask(int index, DownloadTaskModel newTask) async {
    tasks[index] = newTask;
    notifyListeners();
    var box = await HiveBox.downloadTasks;
    await box.put(newTask.id, newTask);
  }

  // this will mark a task with a flag(downloading, finished, etc..)
  Future<void> _markDownloadTask(
    String downloadTaskID,
    TaskStatus taskStatus,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) async {
    int index = tasks.indexWhere((element) => element.id == downloadTaskID);
    DownloadTaskModel newTask = tasks[index];
    newTask.taskStatus = taskStatus;

    _updateTask(index, newTask);

    if (taskStatus == TaskStatus.finished) {
      newTask.finishedAt = DateTime.now();
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
      late PeerModel me;
      late PeerModel remotePeer;
      late String laptopDownloadUrl;
      bool laptop = downloadTaskModel.remoteDeviceID == laptopID;
      if (downloadTaskModel.remoteDeviceID != laptopID) {
        me = serverProvider.me(shareProvider);
        remotePeer = serverProvider
            .peerModelWithDeviceID(downloadTaskModel.remoteDeviceID);
      } else {
        laptopDownloadUrl = connectLaptopPF(navigatorKey.currentContext!)
            .getPhoneConnLink(downloadFileEndPoint);
      }

      downloading = true;
      notifyListeners();

      await _markDownloadTask(
        downloadTaskModel.id,
        TaskStatus.downloading,
        serverProvider,
        shareProvider,
      );

      //? new way of downloading with multiple streams for faster downloading speed
      rdu.DownloadTaskController downloadTaskController =
          rdu.DownloadTaskController(
        downloadPath: downloadTaskModel.localFilePath,
        myDeviceID: laptop ? laptopID : me.deviceID,
        mySessionID: laptop ? laptopID : me.sessionID,
        remoteFilePath: downloadTaskModel.remoteFilePath,
        url: laptop
            ? laptopDownloadUrl
            : remotePeer.getMyLink(downloadFileEndPoint),
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
        await _markDownloadTask(
          downloadTaskModel.id,
          TaskStatus.finished,
          serverProvider,
          shareProvider,
        );
      } else {
        throw Exception('Error occurred during download');
      }
    } catch (e, s) {
      await _markDownloadTask(
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
