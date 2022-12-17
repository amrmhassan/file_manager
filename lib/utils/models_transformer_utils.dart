import 'dart:io';

import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

//? a single path to storage item model
StorageItemModel? storageModelFromPath(
  String path, [
  EntityType entityType = EntityType.file,
]) {
  if (entityType == EntityType.file) {
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
      entityType: entityType,
      size: fileStat.size,
    );
    return storageItemModel;
  } else {
    Directory dir = Directory(path);
    if (!dir.existsSync()) {
      return null;
    }
    FileStat fileStat = dir.statSync();
    StorageItemModel storageItemModel = StorageItemModel(
      parentPath: dir.parent.path,
      path: path,
      modified: fileStat.modified,
      accessed: fileStat.accessed,
      changed: fileStat.changed,
      entityType: entityType,
      size: fileStat.size,
    );
    return storageItemModel;
  }
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

//? a list or paths to storage item model with file or directory
List<StorageItemModel> pathsToStorageItemsWithType(
    Iterable<Map<String, dynamic>> data) {
  List<StorageItemModel> items = [];
  if (data.isEmpty) {
    return [];
  }
  for (var element in data) {
    String path = element['path'];
    EntityType entityType = element['type'];
    StorageItemModel? storageItem = storageModelFromPath(path, entityType);
    if (storageItem != null) {
      items.add(storageItem);
    }
  }
  return items;
}
