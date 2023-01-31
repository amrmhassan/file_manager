import 'package:dio/dio.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/utils/files_operations_utils/download_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

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

  Future<void> downloadFile({
    required PeerModel peerModel,
    required String remoteFilePath,
    required String sessionID,
    required String deviceID,
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
      peerModel.getMyLink(downloadFileEndPoint),
      downloadFolderPath,
      deleteOnError: false,
      options: Options(
        headers: {
          filePathHeaderKey: Uri.encodeComponent(remoteFilePath),
          sessionIDHeaderKey: sessionID,
          deviceIDString: deviceID,
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
