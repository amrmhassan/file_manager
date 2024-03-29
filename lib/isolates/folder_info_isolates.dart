import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/models/folder_details_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/general_utils.dart';

//? to get the folder size
FolderDetailsModel calcFolderDetails(String path) {
  Directory directory = Directory(path);
  List<FileSystemEntity> children = getFolderAllItems(path);
  int size = children.fold(
      0, (previousValue, element) => previousValue + element.statSync().size);
  var files = children
      .where((element) => element.statSync().type == FileSystemEntityType.file);
  int folders = children.length - files.length;

  FolderDetailsModel folderDetailsModel = FolderDetailsModel(
    path: directory.path,
    size: size,
    filesCount: files.length,
    folderCount: folders,
  );
  return folderDetailsModel;
}

//? to update folder size in sqlite
void updateFolderSizeInSqlite(
  StorageItemModel storageItemModel,
  int newSize,
) async {
  LocalFolderInfo localFolderInfo = LocalFolderInfo(
    parentPath: storageItemModel.parentPath,
    path: storageItemModel.path,
    modified: storageItemModel.modified,
    accessed: storageItemModel.accessed,
    changed: storageItemModel.changed,
    dateCaptured: DateTime.now(),
    entityType: storageItemModel.entityType,
    size: newSize,
  );
  // await DBHelper.insert(localFolderInfoTableName, localFolderInfo.toJSON());
  (await HiveBox.localFolderInfoTableName).add(localFolderInfo);
}

//? get all folder children
List<FileSystemEntity> getFolderAllItems(String path) {
  try {
    Directory directory = Directory(path);
    List<FileSystemEntity> allChildren = [];
    var children = directory.listSync();
    for (var child in children) {
      allChildren.add(child);
      if (child.statSync().type == FileSystemEntityType.directory) {
        var subChildren = getFolderAllItems(child.path);
        allChildren.addAll(subChildren);
      }
    }
    return allChildren;
  } catch (e) {
    printOnDebug(e);
    return [];
  }
}
