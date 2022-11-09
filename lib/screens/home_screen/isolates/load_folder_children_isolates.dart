import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

//? this should run in the home screen init state
void loadExplorerChildren(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  StreamSubscription<FileSystemEntity>? streamSub;
  sendPort.send(receivePort.sendPort);
  //? this will hold maximum 10 children
  List<StorageItemModel> cachedChildren = [];

  receivePort.listen((message) {
    if (streamSub != null) {
      streamSub!.cancel();
    }
    if (message is String) {
      //? this is a path
      Directory directory = Directory(message);
      var stream = directory.list();
      streamSub = stream.listen((entity) async {
        if (cachedChildren.length > 10) {
          //? here send the list then clear it
          sendPort.send(cachedChildren);
          cachedChildren.clear();
        } else {
          //? here just add to the list
          FileStat entityStat = await entity.stat();
          StorageItemModel storageItemModel = StorageItemModel(
            parentPath: entity.parent.path,
            path: entity.path,
            modified: entityStat.modified,
            accessed: entityStat.accessed,
            changed: entityStat.changed,
            entityType: entityStat.type == FileSystemEntityType.directory
                ? EntityType.folder
                : EntityType.file,
            size: entityStat.type == FileSystemEntityType.directory
                ? null
                : entityStat.size,
          );
          cachedChildren.add(storageItemModel);
        }
      });
    }
  });
}
