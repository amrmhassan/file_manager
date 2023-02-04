import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart';

//? these tasks will be saved into the sqlite for later download
//? downloading might be continued in another session so i provided peer model which wont be saved to sqlite
//? but peer device id will be saved
//? so if peer model is null then this task is being continued in another session

enum TaskStatus {
  pending,
  paused,
  downloading,
  finished,
  failed,
}

class DownloadTaskModel {
  final String id;
  final String peerDeviceID;
  final PeerModel? peerModel;
  final String remoteFilePath;
  final DateTime addedAt;
  final String remoteDeviceName;
  final String remoteDeviceID;
  DownloadTaskController? downloadTaskController;
  final int? size;

  DateTime? finishedAt;
  TaskStatus taskStatus;
  int count;

  DownloadTaskModel({
    required this.remoteDeviceName,
    required this.remoteDeviceID,
    required this.id,
    required this.peerDeviceID,
    required this.remoteFilePath,
    required this.addedAt,
    required this.size,
    this.downloadTaskController,
    this.finishedAt,
    this.count = 0,
    this.taskStatus = TaskStatus.pending,
    this.peerModel,
  });

  //! to json
  Map<String, String> toJSON() {
    return {
      remoteDeviceIDString: remoteDeviceID,
      remoteDeviceNameString: remoteDeviceName,
      idString: id,
      peerDeviceIDString: peerDeviceID,
      remoteFilePathString: remoteFilePath,
      addedAtString: addedAt.toIso8601String(),
      sizeString: size == null ? dbNull : size.toString(),
      countString: count.toString(),
      taskStatusString: taskStatus.name,
      finishedAtString:
          finishedAt == null ? dbNull : finishedAt!.toIso8601String(),
    };
  }
  //! from json

  static DownloadTaskModel fromJSON(Map<String, dynamic> obj) {
    return DownloadTaskModel(
      remoteDeviceID: obj[remoteDeviceIDString],
      remoteDeviceName: obj[remoteDeviceNameString],
      id: obj[idString],
      peerDeviceID: obj[peerDeviceIDString],
      remoteFilePath: obj[remoteFilePathString],
      addedAt: DateTime.parse(obj[addedAtString]),
      size: obj[sizeString] == dbNull ? null : int.parse(obj[sizeString]),
      count: int.parse(obj[countString]),
      taskStatus: stringToEnum(obj[taskStatusString], TaskStatus.values),
      finishedAt: obj[finishedAtString] == dbNull
          ? null
          : DateTime.parse(obj[finishedAtString]),
    );
  }
}
