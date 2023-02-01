// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
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
    required PeerModel remotePeerModel,
    required String mySessionID,
    required String myDeviceID,
  }) {
    DownloadTaskModel downloadTaskModel = DownloadTaskModel(
      id: Uuid().v4(),
      peerDeviceID: remotePeerModel.deviceID,
      remoteFilePath: remoteFilePath,
      addedAt: DateTime.now(),
      size: fileSize,
      taskStatus: TaskStatus.pending,
    );
    tasks.add(downloadTaskModel);
    notifyListeners();
    //? this is to start downloading the task if there is no tasks downloading
    if (tasksFree) {
      _startDownloadFile(
        remotePeerModel: remotePeerModel,
        remoteFilePath: remoteFilePath,
        mySessionID: mySessionID,
        myDeviceID: myDeviceID,
      );
    }
  }

  Future<void> _startDownloadFile({
    required PeerModel remotePeerModel,
    required String remoteFilePath,
    required String mySessionID,
    required String myDeviceID,
    String? customDownloadPath,
  }) async {
    DateTime before = DateTime.now();
    downloading = true;
    notifyListeners();
    String fileName = path_operations.basename(remoteFilePath);
    FileType fileType = getFileTypeFromPath(remoteFilePath);
    String downloadFolderPath = getSaveFilePath(fileType, fileName);

    Dio dio = Dio();
    await dio.download(
      remotePeerModel.getMyLink(downloadFileEndPoint),
      downloadFolderPath,
      deleteOnError: false,
      options: Options(
        headers: {
          filePathHeaderKey: Uri.encodeComponent(remoteFilePath),
          sessionIDHeaderKey: mySessionID,
          deviceIDString: myDeviceID,
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
        }
      },
    );
  }
}
