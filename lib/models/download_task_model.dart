import 'package:explorer/models/peer_model.dart';

//? these tasks will be saved into the sqlite for later download
//? downloading might be continued in another session so i provided peer model which wont be saved to sqlite
//? but peer device id will be saved
//? so if peer model is null then this task is being continued in another session

class DownloadTaskModel {
  final String peerDeviceID;
  final PeerModel? peerModel;
  final String remoteFilePath;

  const DownloadTaskModel({
    required this.peerDeviceID,
    this.peerModel,
    required this.remoteFilePath,
  });

  //! to json
  //! from json
}
