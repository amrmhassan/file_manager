import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

class FolderChildrenIsolate {
  static int getFolderChildrenNumber(String path) {
    Directory directory = Directory(path);
    return directory.listSync().length;
  }

  static List<LocalFileInfo> getFolderChildrenAsLocalFileInfo(
      String folderPath) {
    Directory directory = Directory(folderPath);
    var children = directory.listSync();
    return children.map((e) => LocalFileInfo.fromPath(e.path)).toList();
  }

  static List<StorageItemModel> getFolderChildrenAsStorageItems(
      String folderPath) {
    Directory dir = Directory(folderPath);
    var children = dir.listSync();
    var storageItems = children.map((e) {
      FileStat stat = e.statSync();
      return StorageItemModel(
        parentPath: e.parent.path,
        path: e.path,
        modified: stat.modified,
        accessed: stat.accessed,
        changed: stat.changed,
        entityType: stat.type == FileSystemEntityType.file
            ? EntityType.file
            : EntityType.folder,
        size: stat.size,
      );
    }).toList();
    return storageItems;
  }

  static List<String> getFolderChildrenAsPaths(String folderPath) {
    Directory dir = Directory(folderPath);
    var children = dir.listSync();
    return children.map((e) => e.path).toList();
  }

  static List<String> getFolderChildrenAsPathsRecursive(String folderPath) {
    Directory dir = Directory(folderPath);
    var children = dir.listSync(recursive: true);
    return children.map((e) => e.path).toList();
  }
}
