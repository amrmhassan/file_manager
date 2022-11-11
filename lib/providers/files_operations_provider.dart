import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path_operations;

class FilesOperationsProvider extends ChangeNotifier {
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
