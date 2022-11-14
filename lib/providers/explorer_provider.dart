import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/isolates/load_folder_children_isolates.dart';
import 'package:explorer/utils/directory_watchers.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ExplorerProvider extends ChangeNotifier {
  final List<StorageItemModel> _children = [];
  List<StorageItemModel> get children => _children;
  SendPort? globalSendPort;

  bool loadingChildren = false;
  String? error;
  Directory currentActiveDir = initialDir;
  StreamSubscription<FileSystemEntity>? streamSub;
  StreamSubscription? watchDirStreamSub;

  ExplorerProvider() {
    runTheIsolate();
  }
  int? parentSize;

  //? selected from the current active folder
  List<StorageItemModel> _selectedFromCurrentActiveDir = [];
  List<StorageItemModel> get selectedFromCurrentActiveDir {
    return [..._selectedFromCurrentActiveDir];
  }

  //? to add to the selected from current dir
  void addToSelectedFromCurrentDir(StorageItemModel s) {
    if (!_selectedFromCurrentActiveDir
        .any((element) => element.path == s.path)) {
      _selectedFromCurrentActiveDir.add(s);
      notifyListeners();
    }
  }

  //? to remove from the selected from current dir
  void removeFromSelectedFromCurrentDir(String path) {
    _selectedFromCurrentActiveDir.removeWhere(
      (element) => element.path == path,
    );
    notifyListeners();
  }

  //? to clear the ...
  void clearSelectedFromActiveDir() {
    _selectedFromCurrentActiveDir.clear();
    notifyListeners();
  }

  //? is all in the current active folder selected or not
  bool get allActiveDirChildrenSelected {
    return _selectedFromCurrentActiveDir.length == _children.length;
  }

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
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    if (currentActiveDir.parent.path == '.') return;
    setActiveDir(
      path: currentActiveDir.parent.path,
      sizesExplorer: sizesExplorer,
      analyzerProvider: analyzerProvider,
      filesOperationsProvider: filesOperationsProvider,
    );
  }

  //? go home
  void goHome({
    required AnalyzerProvider? analyzerProvider,
    required bool sizesExplorer,
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    setActiveDir(
      path: initialDir.path,
      analyzerProvider: analyzerProvider,
      sizesExplorer: sizesExplorer,
      filesOperationsProvider: filesOperationsProvider,
    );
  }

//? update the selected items from the current dir when ever the active dir changes
  void updateSelectedFromActiveDir({
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    _selectedFromCurrentActiveDir = filesOperationsProvider.selectedItems
        .where((element) => element.parentPath == currentActiveDir.path)
        .toList();
    notifyListeners();
  }

//? update the active dir
  void setActiveDir({
    required String path,
    AnalyzerProvider? analyzerProvider,
    bool sizesExplorer = false,
    required FilesOperationsProvider filesOperationsProvider,
  }) {
    currentActiveDir = Directory(path);
    //* run folder watchers
    _runActiveDirWatchers();
    updateSelectedFromActiveDir(
        filesOperationsProvider: filesOperationsProvider);

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

  void _runActiveDirWatchers() {
    DirecotryWatchers direcotryWatchers =
        DirecotryWatchers(currentActiveDir: currentActiveDir);
    //* add entity watcher
    direcotryWatchers.createWatcher(callback: (storageItemModel) {
      bool contain = false;
      for (var entity in _children) {
        if (entity.path == storageItemModel.path) {
          contain = true;
          break;
        }
      }
      if (!contain) {
        _children.add(storageItemModel);
        notifyListeners();
      }
    });
  }
}
