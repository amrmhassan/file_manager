import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

//? a single path to storage item model
StorageItemModel? storageModelFromPath(String path) {
  File file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  FileStat fileStat = file.statSync();
  StorageItemModel storageItemModel = StorageItemModel(
    parentPath: file.parent.path,
    path: path,
    modified: fileStat.modified,
    accessed: fileStat.accessed,
    changed: fileStat.changed,
    entityType: EntityType.file,
    size: fileStat.size,
  );
  return storageItemModel;
}

//? a list of paths to storage item model
List<StorageItemModel> pathsToStorageItems(Iterable<String> paths) {
  List<StorageItemModel> items = [];
  if (paths.isEmpty) {
    return [];
  }
  for (var path in paths) {
    StorageItemModel? storageItem = storageModelFromPath(path);
    if (storageItem != null) {
      items.add(storageItem);
    }
  }
  return items;
}
