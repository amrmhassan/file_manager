import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart';

class DownloadFolderController extends DownloadTaskController {
  late List<ShareSpaceItemModel> folders;
  late List<ShareSpaceItemModel> files;
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
    super.maximumParallelDownloadThreads,
  });

  Future startDownload() async {
    var res = await Dio().get(
      url,
      options: Options(
        headers: {
          folderPathHeaderKey: Uri.encodeComponent(remoteFilePath),
          sessionIDHeaderKey: mySessionID,
        },
      ),
    );
    var data = res.data as List;
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    print(items);
  }
}
