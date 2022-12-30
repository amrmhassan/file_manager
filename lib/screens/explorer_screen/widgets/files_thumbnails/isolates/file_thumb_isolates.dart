// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as im;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//# the error with compute method was fixed by moving getTemporaryDirectory to the main isolate before calling the compute method then passing it to the sub isolate
//? the actual code to compress image
Future<String> compressImageIsolateActualCode(
  String rawImagePath,
  String destFolder,
) async {
  String compressedImagePath = await createImageThumbnail(
    sourcePath: rawImagePath,
    destFolder: destFolder,
    compressWidthTo: (largeIconSize * 2).toInt(),
  );
  return compressedImagePath;
}

//? this will compress an image and check for it in sqlite
Future<void> createFileThumbnail(
  String rawFilePath,
  Function(String path) setThumbnail,
  FileType fileType,
) async {
  var data = await DBHelper.getDataWhere(
    thumbnailPathTableName,
    pathString,
    rawFilePath,
    persistentDbName,
  );

  if (!(data.isEmpty || data.first.values.isEmpty)) {
    String thumbnail = data.first.values.last;
    File thumbFile = File(thumbnail);
    bool exists = thumbFile.existsSync();

    if (exists) return setThumbnail(thumbnail);
  }

  Directory tempDir = await getTemporaryDirectory();
  late String compressedImagePath;
  if (fileType == FileType.image) {
    //* image thumbnail
    compressedImagePath = await compute(
      (msg) => compressImageIsolateActualCode(rawFilePath, tempDir.path),
      '',
    );
  } else if (fileType == FileType.video) {
    //* video thumbnail
    compressedImagePath = await createVideoThumbnail(rawFilePath);
  } else if (fileType == FileType.apk) {
    compressedImagePath = await createAPKThumbnail(rawFilePath);
  }

  await DBHelper.insert(
    thumbnailPathTableName,
    {
      pathString: rawFilePath,
      thumbnailStringPath: compressedImagePath,
    },
    persistentDbName,
  );
  setThumbnail(compressedImagePath);
}

//? to compress an image and save it
Future<String> createImageThumbnail({
  required String sourcePath,
  int compressWidthTo = 50,
  String destFolder = './data/output/',
  int quality = 100,
}) async {
  File sourceFile = File(sourcePath);
  im.Image image = im.decodeImage(sourceFile.readAsBytesSync())!;
  int imageWidth = image.width;
  int imageHeight = image.height;
  double compressionFactor = imageWidth / compressWidthTo;
  // new width and height
  int newWidth = imageWidth ~/ compressionFactor;
  int newHeight = imageHeight ~/ compressionFactor;

  var compressedImage =
      im.copyResize(image, height: newHeight, width: newWidth);
  String newPath = '$destFolder/${basename(sourcePath)}';
  newPath = createNewPath(newPath.replaceAll('//', '/'));

  File(newPath).writeAsBytesSync(
    im.encodeJpg(
      compressedImage,
      quality: quality,
    ),
  );
  return newPath;
}

//? to create  a video thumbnail
Future<String> createVideoThumbnail(String sourcePath) async {
  MethodChannel channel = MethodChannel('amh.fileManager.com/video_thumbnail');
  Directory tempDir = await getTemporaryDirectory();
  String thumbnailPath =
      '${tempDir.path}/${basename(sourcePath).replaceAll(".mp4", ".jpg")}';
  String thumbnail = await channel.invokeMethod('handleVideo', {
    'filePath': sourcePath,
    'time': 0,
    'output': createNewPath(thumbnailPath),
  });
  return thumbnail;
}

//? to create an apk thumbnail
Future<String> createAPKThumbnail(String sourcePath) async {
  MethodChannel channel = MethodChannel('amh.fileManager.com/video_thumbnail');
  Directory tempDir = await getTemporaryDirectory();
  String thumbnailPath = createNewPath(
      '${tempDir.path}/${basename(sourcePath).replaceAll(".apk", ".jpg")}');
  String apkThumbnail = await channel.invokeMethod('handleAPK', {
    'filePath': sourcePath,
    'output': thumbnailPath,
  });
  return apkThumbnail;
}
