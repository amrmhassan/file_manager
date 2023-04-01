import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:explorer/utils/download_utils/custom_dio.dart';

class DownloadUpdate {
  static Future<String> get getUpdateFolderPath async {
    return '${(await getTemporaryDirectory()).path}/afm_update';
  }

  static Future<String> getUpdateFilePath(String latestVersionName) async {
    return '${await getUpdateFolderPath}/$latestVersionName.exe';
  }

  Future<String> downloadUpdate(String link, String version) async {
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    var downloadDir = await getUpdateFolderPath;
    if (!Directory(downloadDir).existsSync()) {
      Directory(downloadDir).createSync();
    } else {
      Directory(downloadDir).deleteSync(recursive: true);
      Directory(downloadDir).createSync();
    }
    String fileName = '$version.exe';
    String filePath = '$downloadDir/$fileName';
    await CustomDio().download(
      link,
      filePath,
      deleteIfExist: true,
    );
    return filePath;
  }
}
