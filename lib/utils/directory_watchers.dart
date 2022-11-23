// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';

//? to watch the active dir for any changes and update the UI
class DirecotryWatchers {
  StreamSubscription? _createSub;
  Directory currentActiveDir;

  DirecotryWatchers({
    required this.currentActiveDir,
  });

  //! 1=> add (copy)
  //! 4=> delete

  //! 8 => rename

  //? create watcher
  void createWatcher({
    required Function(StorageItemModel s) callback,
  }) {
    if (_createSub != null) {
      _createSub!.cancel();
    }
    _createSub = currentActiveDir.watch().listen((event) {
      printOnDebug(event.type);
      printOnDebug(event.path);
      StorageItemModel storageItemModel;
      if (event.isDirectory) {
        Directory dir = Directory(event.path);
        FileStat fileStat = dir.statSync();
        storageItemModel = StorageItemModel(
          parentPath: dir.parent.path,
          path: dir.path,
          modified: fileStat.modified,
          accessed: fileStat.accessed,
          changed: fileStat.changed,
          entityType: EntityType.folder,
          size: 0,
        );
      } else {
        File file = File(event.path);
        FileStat fileStat = file.statSync();
        storageItemModel = StorageItemModel(
          parentPath: file.parent.path,
          path: file.path,
          modified: fileStat.modified,
          accessed: fileStat.accessed,
          changed: fileStat.changed,
          entityType: EntityType.file,
          size: fileStat.size,
        );
      }

      callback(storageItemModel);
    });
  }
}

// void handleWatchCreateWithinActiveDir({
//   required Directory currentActiveDir,
//   required StreamSubscription? watchDirStreamSub,
//   required Function(StorageItemModel s) callback,
// }) {
//   if (watchDirStreamSub != null) {
//     watchDirStreamSub.cancel();
//   }
//   var watchStream = currentActiveDir.watch();
//   watchDirStreamSub = watchStream.listen((event) {
//     StorageItemModel storageItemModel;
//     if (event.isDirectory) {
//       Directory dir = Directory(event.path);
//       FileStat fileStat = dir.statSync();
//       storageItemModel = StorageItemModel(
//         parentPath: dir.parent.path,
//         path: dir.path,
//         modified: fileStat.modified,
//         accessed: fileStat.accessed,
//         changed: fileStat.changed,
//         entityType: EntityType.folder,
//         size: 0,
//       );
//     } else {
//       File file = File(event.path);
//       FileStat fileStat = file.statSync();
//       storageItemModel = StorageItemModel(
//         parentPath: file.parent.path,
//         path: file.path,
//         modified: fileStat.modified,
//         accessed: fileStat.accessed,
//         changed: fileStat.changed,
//         entityType: EntityType.file,
//         size: fileStat.size,
//       );
//     }

//     callback(storageItemModel);
//   });
// }
