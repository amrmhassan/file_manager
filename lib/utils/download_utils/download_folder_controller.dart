import 'package:explorer/utils/download_utils/download_task_controller.dart';

class DownloadFolderController extends DownloadTaskController {
  DownloadFolderController({
    required super.downloadPath,
    required super.myDeviceID,
    required super.mySessionID,
    required super.remoteFilePath,
    required super.url,
    required super.setProgress,
    required super.setSpeed,
    required super.remoteDeviceID,
    required super.remoteDeviceName,
  });
}
