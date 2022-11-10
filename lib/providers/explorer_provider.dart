import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/isolates/load_folder_children_isolates.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ExplorerProvider extends ChangeNotifier {
  final List<StorageItemModel> _children = [];
  List<StorageItemModel> get ch => _children;
  SendPort? globalSendPort;
  ExplorerProvider() {
    runTheIsolate();
  }
  int? parentSize;
  //? to update the parent size if in sizes explorer mode
  void updateParentSize(AnalyzerProvider analyzerProvider) async {
    //? here i will update the current active dir size
    LocalFolderInfo? localFolderInfo =
        await analyzerProvider.getDirInfoByPath(currentActiveDir.path);
    if (localFolderInfo != null && localFolderInfo.size != null) {
      parentSize = localFolderInfo.size;
      notifyListeners();
    }
  }

  Future<List<StorageItemModel>> viewedChildren(
    BuildContext context, [
    bool sizesExplorer = false,
  ]) async {
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

  void goBack({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
  }) {
    if (currentActiveDir.parent.path == '.') return;
    setActiveDir(
      path: currentActiveDir.parent.path,
      sizesExplorer: sizesExplorer,
      analyzerProvider: analyzerProvider,
    );
  }

  //? go home
  void goHome({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
  }) {
    setActiveDir(
        path: initialDir.path,
        analyzerProvider: analyzerProvider,
        sizesExplorer: sizesExplorer);
  }

  void setActiveDir({
    required String path,
    AnalyzerProvider? analyzerProvider,
    bool sizesExplorer = false,
  }) {
    currentActiveDir = Directory(path);
    notifyListeners();
    _updateViewedChildren();
    if (sizesExplorer && analyzerProvider != null) {
      updateParentSize(analyzerProvider);
    }
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
