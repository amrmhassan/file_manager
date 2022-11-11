//? to watch the active dir for any changes and update the UI
import 'dart:async';
import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

class DirecotryWatchers {
  StreamSubscription? _addSub;
  StreamSubscription? _removeSub;
  StreamSubscription? _renameSub;
  Directory currentActiveDir;

  DirecotryWatchers({
    required this.currentActiveDir,
  });

  //? add watcher
  void addWatcher({
    required Function(StorageItemModel s) callback,
  }) {
    if (_addSub != null) {
      _addSub!.cancel();
    }
    var watchStream = currentActiveDir.watch();
    _addSub = watchStream.listen((event) {
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
