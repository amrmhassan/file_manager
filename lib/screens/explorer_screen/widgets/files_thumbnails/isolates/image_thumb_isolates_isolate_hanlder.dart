// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'package:explorer/constants/db_constants.dart';
// import 'package:explorer/constants/models_constants.dart';
// import 'package:explorer/constants/sizes.dart';
// import 'package:explorer/helpers/db_helper.dart';
// import 'package:flutter_native_image/flutter_native_image.dart' as fni;
// import 'package:isolate_handler/isolate_handler.dart';

// final IsolateHandler isolates = IsolateHandler();

// //? the actual code to compress image
// Future<String> compressImageIsolateActualCode(String rawImagePath) async {
//   fni.ImageProperties properties =
//       await fni.FlutterNativeImage.getImageProperties(rawImagePath);
//   int width = properties.width!;
//   int height = properties.height!;

//   double widthHeightRatio = width / height;

//   int newWidth = (largeIconSize * 2).toInt();
//   int newHeight = newWidth ~/ widthHeightRatio;

//   File compressedFile = await fni.FlutterNativeImage.compressImage(
//     rawImagePath,
//     quality: 100,
//     targetWidth: newWidth,
//     targetHeight: newHeight,
//   );

//   return compressedFile.path;
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
//   isolates.spawn<String>(
//     entryPoint,
//     name: rawImagePath,
//     // Executed every time data is received from the spawned isolate.
//     onReceive: (compressedImagePath) async {
//       await DBHelper.insert(
//         imgThumbnailPathTableName,
//         {
//           pathString: rawImagePath,
//           thumbnailStringPath: compressedImagePath,
//         },
//         persistentDbName,
//       );

//       setThumbnail(compressedImagePath);
//       isolates.kill(rawImagePath, priority: Isolate.beforeNextEvent);
//     },
//     // Executed once when spawned isolate is ready for communication.
//     onInitialized: () => isolates.send(rawImagePath, to: rawImagePath),
//   );
// }

// void entryPoint(Map<String, dynamic> context) {
//   final messenger = HandledIsolate.initialize(context);

//   messenger.listen((rawImagePath) async {
//     if (rawImagePath is String) {
//       String compressedImagePath =
//           await compressImageIsolateActualCode(rawImagePath);
//       messenger.send(compressedImagePath);
//     }
//   });
// }
