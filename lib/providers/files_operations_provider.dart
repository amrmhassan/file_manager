import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path_operations;

enum FileOparation {
  delete,
  move,
  copy,
  send,
}

enum ExplorMode {
  selection,
  normal,
}

class FilesOperationsProvider extends ChangeNotifier {
  List<StorageItemModel> selectedItems = [];

  //? to return if a storage  item is selected
  bool isSelected(String path) {
    return selectedItems.any((element) => element.path == path);
  }

//? to get the selection mode if selected items isn't empty and normal if empty
  ExplorMode get explorMode {
    return selectedItems.isEmpty ? ExplorMode.normal : ExplorMode.selection;
  }

//? add to selected items
  void addToSelectedItems(StorageItemModel s) {
    selectedItems.add(s);
    notifyListeners();
  }

  //? remove from selected items
  void removeFromSelectedItems(String path) {
    selectedItems.removeWhere((element) => element.path == path);
    notifyListeners();
  }

//? to toggle from selected items
  void toggleFromSelectedItems(StorageItemModel s) {
    if (selectedItems.any((element) => element.path == s.path)) {
      return removeFromSelectedItems(s.path);
    }
    return addToSelectedItems(s);
  }

  //? create new folder
  void createFolder(
    String newFolderName,
    ExplorerProvider explorerProvider,
  ) {
    bool allowCreation = true;
    Directory parent = explorerProvider.currentActiveDir;
    List<StorageItemModel> children = explorerProvider.children;
    for (var entity in children) {
      if (entity.entityType == EntityType.folder) {
        if (path_operations.basename(entity.path) == newFolderName) {
          allowCreation = false;
          break;
        }
      }
    }
    if (allowCreation) {
      Directory newDir = Directory('${parent.path}/$newFolderName');
      newDir.createSync();
    } else {
      throw Exception('This Folder already exists');
    }
  }
}
