import 'package:explorer/models/peer_model.dart';

//? these tasks will be saved into the sqlite for later download
//? downloading might be continued in another session so i provided peer model which wont be saved to sqlite
//? but peer device id will be saved
//? so if peer model is null then this task is being continued in another session

enum TaskStatus {
  pending,
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
  TaskStatus taskStatus;
  // downloaded file size in bytes
  final int? size;
  int? count;

  DownloadTaskModel({
    required this.id,
    required this.peerDeviceID,
    required this.remoteFilePath,
    required this.addedAt,
    required this.size,
    this.count = 0,
    this.taskStatus = TaskStatus.pending,
    this.peerModel,
  });

  //! to json
  //! from json
}
