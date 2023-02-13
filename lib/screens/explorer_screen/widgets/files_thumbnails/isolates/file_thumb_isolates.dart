// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//? this will compress an image and check for it in sqlite
Future<void> getFileThumbnail(
  String rawFilePath,
  Function(String path) setThumbnail,
  FileType fileType,
) async {
  // var data = await DBHelper.getDataWhere(
  //   thumbnailPathTableName,
  //   pathString,
  //   rawFilePath,
  //   persistentDbName,
  // );
  var data = (await HiveBox.thumbnailPathTableName).get(rawFilePath);

  if (!(data == null)) {
    String thumbnail = data.values.last;
    File thumbFile = File(thumbnail);
    bool exists = thumbFile.existsSync();

    if (exists) return setThumbnail(thumbnail);
  }

  try {
    // Directory tempDir = await getTemporaryDirectory();
    late String compressedImagePath;
    if (fileType == FileType.image) {
      compressedImagePath = await createImageThumbnailKotlin(rawFilePath);
    } else if (fileType == FileType.video) {
      //* video thumbnail
      compressedImagePath = await createVideoThumbnail(rawFilePath);
    } else if (fileType == FileType.apk) {
      compressedImagePath = await createAPKThumbnail(rawFilePath);
    }

    // await DBHelper.insert(
    //   thumbnailPathTableName,
    //   {
    //     pathString: rawFilePath,
    //     thumbnailStringPath: compressedImagePath,
    //   },
    //   persistentDbName,
    // );
    (await HiveBox.thumbnailPathTableName).put(rawFilePath, {
      pathString: rawFilePath,
      thumbnailStringPath: compressedImagePath,
    });
    setThumbnail(compressedImagePath);
  } catch (e) {
    printOnDebug('cant generate thumbnail');
  }
}

//? create image thumbnail with kotlin

Future<String> createImageThumbnailKotlin(String sourcePath) async {
  MethodChannel channel = MethodChannel('amh.fileManager.com/create_thumbnail');
  Directory tempDir = await getTemporaryDirectory();
  String thumbnailPath =
      createNewPath('${tempDir.path}/${basename(sourcePath)}');
  String thumbnail = await channel.invokeMethod('handleImage', {
    'filePath': sourcePath,
    'time': 0,
    'output': thumbnailPath,
    'width': (largeIconSize * 1.5).toInt(),
  });
  if (thumbnail == 'error') {
    throw Exception('Can\'t generate a thumbnail');
  }
  return thumbnail;
}

//? to create  a video thumbnail
Future<String> createVideoThumbnail(String sourcePath) async {
  MethodChannel channel = MethodChannel('amh.fileManager.com/create_thumbnail');
  Directory tempDir = await getTemporaryDirectory();
  String thumbnailPath = createNewPath(
      '${tempDir.path}/${basename(sourcePath).replaceAll(".mp4", ".jpg")}');
  String thumbnail = await channel.invokeMethod('handleVideo', {
    'filePath': sourcePath,
    'time': 0,
    'output': thumbnailPath,
    'width': (largeIconSize * 1.5).toInt(),
  });
  if (thumbnail == 'error') {
    throw Exception('Can\'t generate a thumbnail');
  }
  return thumbnail;
}

//? to create an apk thumbnail
Future<String> createAPKThumbnail(String sourcePath) async {
  MethodChannel channel = MethodChannel('amh.fileManager.com/create_thumbnail');
  Directory tempDir = await getTemporaryDirectory();
  String thumbnailPath = createNewPath(
      '${tempDir.path}/${basename(sourcePath).replaceAll(".apk", ".jpg")}');
  String apkThumbnail = await channel.invokeMethod('handleAPK', {
    'filePath': sourcePath,
    'output': thumbnailPath,
    'width': (largeIconSize * 1.5).toInt(),
  });
  if (apkThumbnail == 'error') {
    throw Exception('Can\'t generate a thumbnail');
  }
  return apkThumbnail;
}
