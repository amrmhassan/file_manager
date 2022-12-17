import 'dart:async';
import 'dart:io';
import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
// import 'package:flutter_native_image/flutter_native_image.dart' as fni;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:path/path.dart' as path_operations;

//? the actual code to compress image
Future<String> compressImageIsolateActualCode(String rawImagePath) async {
  // fni.ImageProperties properties =
  //     await fni.FlutterNativeImage.getImageProperties(rawImagePath);
  // int width = properties.width!;
  // int height = properties.height!;

  // double widthHeightRatio = width / height;

  // int newWidth = (largeIconSize * 2).toInt();
  // int newHeight = newWidth ~/ widthHeightRatio;

  // File compressedFile = await fni.FlutterNativeImage.compressImage(
  //   rawImagePath,
  //   quality: 100,
  //   targetWidth: newWidth,
  //   targetHeight: newHeight,
  // );

//! start of the new method
  Directory tempDir = await pp.getTemporaryDirectory();
  String baseName = path_operations.basename(rawImagePath);
  DateTime now = DateTime.now();
  String targetPath = '${tempDir.path}/${now.toIso8601String()}_$baseName';
  File compressedFile = await FlutterImageCompress.compressAndGetFile(
    rawImagePath,
    targetPath,
    quality: 10,
  ) as File;
  print(compressedFile.statSync().size.toKB);
  return compressedFile.path;
}

//? this will compress an image and check for it in sqlite
Future<void> compressImage(
  String rawImagePath,
  Function(String path) setThumbnail,
) async {
  // var data = await DBHelper.getDataWhere(
  //   imgThumbnailPathTableName,
  //   pathString,
  //   rawImagePath,
  //   persistentDbName,
  // );

  // if (!(data.isEmpty || data.first.values.isEmpty)) {
  //   String thumbnail = data.first.values.last;
  //   File thumbFile = File(thumbnail);
  //   bool exists = thumbFile.existsSync();

  //   if (exists) return setThumbnail(thumbnail);
  // }

  String compressedImagePath =
      await flutterCompute(compressImageIsolateActualCode, rawImagePath);
  await DBHelper.insert(
    imgThumbnailPathTableName,
    {
      pathString: rawImagePath,
      thumbnailStringPath: compressedImagePath,
    },
    persistentDbName,
  );

  setThumbnail(compressedImagePath);
}
