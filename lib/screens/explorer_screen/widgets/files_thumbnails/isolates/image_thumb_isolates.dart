import 'dart:io';
import 'dart:isolate';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter_native_image/flutter_native_image.dart' as fni;

//? to run the compress image isolate and send messages
void runCompressIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((path) async {
    String compressedPath = await compressImageIsolate(path);
    sendPort.send(compressedPath);
  });
}

//? to compress image in isolate
Future<String> compressImageIsolate(String path) async {
  fni.ImageProperties properties =
      await fni.FlutterNativeImage.getImageProperties(path);
  int width = properties.width!;
  int height = properties.height!;

  double widthHeightRatio = width / height;

  int newWidth = (largeIconSize * 2).toInt();
  int newHeight = newWidth ~/ widthHeightRatio;

  File compressedFile = await fni.FlutterNativeImage.compressImage(
    path,
    quality: 100,
    targetWidth: newWidth,
    targetHeight: newHeight,
  );
  return compressedFile.path;
}

//? this will compress an image and check for it in sqlite
Future<void> compressImage(
    String imagePath, Function(String path) setThumbnail) async {
  try {
    var data = await DBHelper.getDataWhere(
      imgThumbnailPathTableName,
      pathString,
      imagePath,
      persistentDbName,
    );
    String thumbnail = data.first.values.last;
    File thumbFile = File(thumbnail);
    bool exists = thumbFile.existsSync();
    if (exists) {
      setThumbnail(thumbnail);
    } else {
      throw Exception('no thumb');
    }
  } catch (e) {
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    Isolate.spawn(runCompressIsolate, sendPort);
    sendPort.send(imagePath);
    receivePort.listen((compressedFilePath) async {
      try {
        await DBHelper.insert(
          imgThumbnailPathTableName,
          {
            pathString: imagePath,
            thumbnailStringPath: compressedFilePath,
          },
          persistentDbName,
        );
        setThumbnail(compressedFilePath);
      } catch (e) {
        printOnDebug(e);
      }
    });
  }
}
