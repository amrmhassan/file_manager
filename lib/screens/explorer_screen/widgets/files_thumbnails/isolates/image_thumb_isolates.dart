import 'dart:async';
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
  late StreamSubscription s;
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  s = receivePort.listen((path) async {
    String compressedPath = await compressImageIsolate(path);
    sendPort.send(compressedPath);
    s.cancel();
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
  String imagePath,
  Function(String path) setThumbnail,
  Function(StreamSubscription s) setStreamSub,
  Function(Isolate s) setIsolate,
) async {
  var data = await DBHelper.getDataWhere(
    imgThumbnailPathTableName,
    pathString,
    imagePath,
    persistentDbName,
  );
  if (!(data.isEmpty || data.first.values.isEmpty)) {
    String thumbnail = data.first.values.last;
    File thumbFile = File(thumbnail);
    bool exists = thumbFile.existsSync();
    if (exists) return setThumbnail(thumbnail);
  }

  late StreamSubscription s;
  ReceivePort receivePort = ReceivePort();
  SendPort sendPort = receivePort.sendPort;
  Isolate isolate = await Isolate.spawn(runCompressIsolate, sendPort);
  sendPort.send(imagePath);
  s = receivePort.listen((compressedFilePath) async {
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
      s.cancel();
      isolate.kill();
    } catch (e) {
      printOnDebug(e);
      s.cancel();
      isolate.kill();
    }
  });
  setStreamSub(s);
  setIsolate(isolate);
}
