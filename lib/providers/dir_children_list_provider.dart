import 'dart:async';
import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ExplorerProvider extends ChangeNotifier {
  final List<StorageItemModel> _children = [];
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

  void _updateViewedChildren() async {
    if (streamSub != null) {
      await streamSub!.cancel();
    }
    Stream<FileSystemEntity> chidrenStream = currentActiveDir.list();
    error = null;
    loadingChildren = true;
    _children.clear();
    notifyListeners();
    streamSub = chidrenStream.listen((entity) {
      FileStat fileStat = entity.statSync();
      StorageItemModel storageItemModel = StorageItemModel(
        parentPath: entity.parent.path,
        path: entity.path,
        modified: fileStat.modified,
        accessed: fileStat.accessed,
        changed: fileStat.changed,
        entityType: fileStat.type == FileSystemEntityType.directory
            ? EntityType.folder
            : EntityType.file,
        size: fileStat.type == FileSystemEntityType.directory
            ? null
            : fileStat.size,
      );
      _children.add(storageItemModel);
      if (_children.length % 10 == 0) {
        notifyListeners();
      }
    });

    streamSub!.onError((e, s) {
      error = e.toString();
      notifyListeners();
    });

    streamSub!.onDone(() {
      loadingChildren = false;
      notifyListeners();
    });
  }

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
}
