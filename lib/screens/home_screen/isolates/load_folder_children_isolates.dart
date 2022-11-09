// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

//! add a counter to send the data after receiving for example 3 chuncks of data
//! then clear the list then add agian until done
class LoadChildrenMessagesData {
  final LoadChildrenMessagesFlags flag;
  final dynamic data;

  const LoadChildrenMessagesData({
    required this.data,
    required this.flag,
  });
}

enum LoadChildrenMessagesFlags {
  done,
  error,
  sendPort,
  childrenChunck,
}

//? this should run in the home screen init state
void loadExplorerChildren(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  //? this will hold maximum 10 children

  receivePort.listen((message) {
    if (message is String) {
      //? this is a path (getting a dir children)
      _listingDirChildren(message, sendPort);
    }
  });
}

//? here run the listing children
void _listingDirChildren(String path, SendPort sendPort) {
  StreamSubscription<FileSystemEntity>? streamSub;
  if (streamSub != null) {
    streamSub.cancel();
  }
  List<StorageItemModel> cachedChildren = [];
  Directory directory = Directory(path);
  var stream = directory.list();
  streamSub = stream.listen((entity) async {
    if (cachedChildren.length > 100) {
      //? here send the list then clear it
      sendPort.send(
        LoadChildrenMessagesData(
            data: cachedChildren,
            flag: LoadChildrenMessagesFlags.childrenChunck),
      );
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

  streamSub.onDone(
    () {
      sendPort.send(
        LoadChildrenMessagesData(
          data: cachedChildren,
          flag: LoadChildrenMessagesFlags.done,
        ),
      );
    },
  );

  streamSub.onError((error) {
    sendPort.send(
      LoadChildrenMessagesData(
          data: error, flag: LoadChildrenMessagesFlags.error),
    );
  });
}
