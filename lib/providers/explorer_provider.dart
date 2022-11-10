import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/isolates/load_folder_children_isolates.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ExplorerProvider extends ChangeNotifier {
  final List<StorageItemModel> _children = [];
  List<StorageItemModel> get ch => _children;
  ExplorerProvider() {
    runTheIsolate();
  }

  SendPort? globalSendPort;

  Future<List<StorageItemModel>> viewedChildren(BuildContext context,
      [bool sizesExplorer = false]) async {
    if (sizesExplorer) {
      List<StorageItemModel> items = [];

      for (var i = 0; i < _children.length; i++) {
        StorageItemModel child = _children[i];
        int? entitySize;
        if (child.entityType == EntityType.folder) {
          LocalFolderInfo? localFolderInfo =
              await Provider.of<AnalyzerProvider>(context, listen: false)
                  .getDirInfoByPath(child.path);
          if (localFolderInfo != null) {
            entitySize = localFolderInfo.size ?? 0;
          }
        } else {
          FileStat fileStat = await File(child.path).stat();
          entitySize = fileStat.size;
        }
        StorageItemModel updatedStoraItemModel = StorageItemModel(
          parentPath: child.parentPath,
          path: child.path,
          modified: child.modified,
          accessed: child.accessed,
          changed: child.changed,
          entityType: child.entityType,
          size: entitySize,
        );
        items.add(updatedStoraItemModel);
      }
      items.sort(
        (a, b) => (b.size ?? 0).compareTo(a.size ?? 0),
      );
      return items;
    } else {
      return getFixedEntityList(_children);
    }
  }

  bool loadingChildren = false;
  String? error;
  Directory currentActiveDir = initialDir;
  StreamSubscription<FileSystemEntity>? streamSub;

  // void _updateViewedChildren() async {
  //   if (streamSub != null) {
  //     await streamSub!.cancel();
  //   }
  //   Stream<FileSystemEntity> chidrenStream = currentActiveDir.list();
  //   error = null;
  //   loadingChildren = true;
  //   _children.clear();
  //   notifyListeners();
  //   streamSub = chidrenStream.listen((entity) {
  //     FileStat fileStat = entity.statSync();
  //     StorageItemModel storageItemModel = StorageItemModel(
  //       parentPath: entity.parent.path,
  //       path: entity.path,
  //       modified: fileStat.modified,
  //       accessed: fileStat.accessed,
  //       changed: fileStat.changed,
  //       entityType: fileStat.type == FileSystemEntityType.directory
  //           ? EntityType.folder
  //           : EntityType.file,
  //       size: fileStat.type == FileSystemEntityType.directory
  //           ? null
  //           : fileStat.size,
  //     );
  //     _children.add(storageItemModel);
  //     if (_children.length % 100 == 0) {
  //       print('Herer');
  //       print(_children.length);
  //       notifyListeners();
  //     }
  //   });

  //   streamSub!.onError((e, s) {
  //     error = e.toString();
  //     notifyListeners();
  //   });

  //   streamSub!.onDone(() {
  //     loadingChildren = false;
  //     notifyListeners();
  //   });
  // }

  void goBack() {
    if (currentActiveDir.parent.path == '.') return;
    setActiveDir(currentActiveDir.parent.path);
  }

  //? go home
  void goHome() {
    setActiveDir(initialDir.path);
  }

  void setActiveDir(String path) {
    currentActiveDir = Directory(path);
    notifyListeners();
    _updateViewedChildren();
  }

//? add chunk to children list
  void addToList(List<StorageItemModel> chunk) {
    _children.addAll(chunk);
    notifyListeners();
  }

  //? trying isolates with the provider

  void runTheIsolate() {
    var receivePort = ReceivePort();
    var sendPort = receivePort.sendPort;
    Isolate.spawn(loadExplorerChildren, sendPort);
    receivePort.listen((message) {
      if (message is SendPort) {
        globalSendPort = message;
      } else if (message is LoadChildrenMessagesData) {
        if (message.flag == LoadChildrenMessagesFlags.childrenChunck) {
          _children.addAll(message.data);
          notifyListeners();
        } else if (message.flag == LoadChildrenMessagesFlags.done) {
          _children.addAll(message.data);
          loadingChildren = false;
          notifyListeners();
        } else if (message.flag == LoadChildrenMessagesFlags.error) {
          error = error.toString();
          notifyListeners();
        }
      }
    });
  }

//? update viewed children
  void _updateViewedChildren() async {
    error = null;
    loadingChildren = true;
    _children.clear();
    notifyListeners();
    if (globalSendPort != null) {
      globalSendPort!.send(currentActiveDir.path);
    }
  }
}
