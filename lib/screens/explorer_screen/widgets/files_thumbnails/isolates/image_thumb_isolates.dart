import 'dart:async';
import 'dart:io';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:image/image.dart' as im;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//? the actual code to compress image
Future<String> compressImageIsolateActualCode(String rawImagePath) async {
  Directory tempDir = await getTemporaryDirectory();
  print('-------------------------------');
  print(tempDir.path);
  print('-------------------------------');
  String compressedImagePath = await customCompressImage(
    sourcePath: rawImagePath,
    destFolder: tempDir.path,
  );
  return compressedImagePath;
}

//? this will compress an image and check for it in sqlite
Future<void> compressImage(
  String rawImagePath,
  Function(String path) setThumbnail,
) async {
  var data = await DBHelper.getDataWhere(
    imgThumbnailPathTableName,
    pathString,
    rawImagePath,
    persistentDbName,
  );

  if (!(data.isEmpty || data.first.values.isEmpty)) {
    String thumbnail = data.first.values.last;
    File thumbFile = File(thumbnail);
    bool exists = thumbFile.existsSync();

    if (exists) return setThumbnail(thumbnail);
  }

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

//? to compress an image and save it
Future<String> customCompressImage({
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
  newPath = newPath.replaceAll('//', '/');
  File(newPath).writeAsBytesSync(
    im.encodeJpg(
      compressedImage,
      quality: quality,
    ),
  );
  return newPath;
}
