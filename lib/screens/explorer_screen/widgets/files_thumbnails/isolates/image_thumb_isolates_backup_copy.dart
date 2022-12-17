// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'package:explorer/constants/db_constants.dart';
// import 'package:explorer/constants/models_constants.dart';
// import 'package:explorer/constants/sizes.dart';
// import 'package:explorer/helpers/db_helper.dart';
// import 'package:flutter_native_image/flutter_native_image.dart' as fni;

// //? to run the compress image isolate and send messages
// void compressIsolate(SendPort sendPort) {
//   ReceivePort receivePort = ReceivePort();
//   sendPort.send(receivePort.sendPort);

//   receivePort.listen((rawImagePath) async {
//     if (rawImagePath is String) {
//       fni.ImageProperties properties =
//           await fni.FlutterNativeImage.getImageProperties(rawImagePath);
//       int width = properties.width!;
//       int height = properties.height!;

//       double widthHeightRatio = width / height;

//       int newWidth = (largeIconSize * 2).toInt();
//       int newHeight = newWidth ~/ widthHeightRatio;

//       File compressedFile = await fni.FlutterNativeImage.compressImage(
//         rawImagePath,
//         quality: 100,
//         targetWidth: newWidth,
//         targetHeight: newHeight,
//       );
//       sendPort.send(compressedFile.path);
//     }
//   });
// }

// //? this will compress an image and check for it in sqlite
// Future<void> compressImage(
//   String rawImagePath,
//   Function(String path) setThumbnail,
// ) async {
//   var data = await DBHelper.getDataWhere(
//     imgThumbnailPathTableName,
//     pathString,
//     rawImagePath,
//     persistentDbName,
//   );

//   if (!(data.isEmpty || data.first.values.isEmpty)) {
//     String thumbnail = data.first.values.last;
//     File thumbFile = File(thumbnail);
//     bool exists = thumbFile.existsSync();

//     if (exists) return setThumbnail(thumbnail);
//   }

//   ReceivePort receivePort = ReceivePort();
//   SendPort sendPort = receivePort.sendPort;
//   Isolate isolate = await Isolate.spawn(compressIsolate, sendPort);

//   receivePort.listen((compressedFilePath) async {
//     if (compressedFilePath is String) {
//       await DBHelper.insert(
//         imgThumbnailPathTableName,
//         {
//           pathString: rawImagePath,
//           thumbnailStringPath: compressedFilePath,
//         },
//         persistentDbName,
//       );
//       setThumbnail(compressedFilePath);
//       isolate.kill();
//     } else if (compressedFilePath is SendPort) {
//       compressedFilePath.send(rawImagePath);
//     }
//   });
// }
