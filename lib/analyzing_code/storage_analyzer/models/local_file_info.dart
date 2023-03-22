//? file info
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart';

part 'local_file_info.g.dart';

@HiveType(typeId: 8)
class LocalFileInfo {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final String parentPath;
  @HiveField(2)
  final DateTime modified;
  @HiveField(3)
  final DateTime accessed;
  @HiveField(4)
  final DateTime changed;
  @HiveField(5)
  final EntityType entityType;
  @HiveField(6)
  final String fileBaseName;
  @HiveField(7)
  final String ext;
  @HiveField(8)
  final int size;

  const LocalFileInfo({
    required this.size,
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.entityType,
    required this.fileBaseName,
    required this.ext,
  });

  // Map<String, String> toJSON() {
  //   return {
  //     parentPathString: parentPath,
  //     pathString: path,
  //     modifiedString: modified.toIso8601String(),
  //     accessedString: accessed.toIso8601String(),
  //     changedString: changed.toIso8601String(),
  //     entityTypeString: entityType.name,
  //     fileBaseNameString: fileBaseName,
  //     sizeString: size.toString(),
  //     extString: ext,
  //   };
  // }

  // static LocalFileInfo fromJSON(Map<String, dynamic> jsonOBJ) {
  //   int size = int.parse(jsonOBJ[sizeString]!);
  //   String parentPath = jsonOBJ[parentPathString]!;
  //   String path = jsonOBJ[pathString]!;
  //   DateTime modified = DateTime.parse(jsonOBJ[modifiedString]!);
  //   DateTime accessed = DateTime.parse(jsonOBJ[accessedString]!);
  //   DateTime changed = DateTime.parse(jsonOBJ[changedString]!);
  //   EntityType entityType =
  //       stringToEnum(jsonOBJ[entityTypeString]!, EntityType.values);
  //   String fileBaseName = jsonOBJ[fileBaseNameString]!;
  //   String ext = jsonOBJ[extString]!;
  //   return LocalFileInfo(
  //     size: size,
  //     parentPath: parentPath,
  //     path: path,
  //     modified: modified,
  //     accessed: accessed,
  //     changed: changed,
  //     entityType: entityType,
  //     fileBaseName: fileBaseName,
  //     ext: ext,
  //   );
  // }

  StorageItemModel toStorageItemModel() {
    return StorageItemModel(
      parentPath: parentPath,
      path: path,
      modified: modified,
      accessed: accessed,
      changed: changed,
      entityType: entityType,
      size: size,
    );
  }

  static LocalFileInfo fromPath(String path) {
    bool isEntityDir = isDir(path);
    if (isEntityDir) {
      Directory dir = Directory(path);
      FileStat stat = dir.statSync();

      return LocalFileInfo(
        size: stat.size,
        parentPath: dir.parent.path,
        path: path,
        modified: stat.modified,
        accessed: stat.accessed,
        changed: stat.changed,
        entityType: EntityType.folder,
        fileBaseName: basename(path),
        ext: getFileExtension(path),
      );
    } else {
      File file = File(path);
      FileStat stat = file.statSync();
      return LocalFileInfo(
        size: stat.size,
        parentPath: file.parent.path,
        path: path,
        modified: stat.modified,
        accessed: stat.accessed,
        changed: stat.changed,
        entityType: EntityType.file,
        fileBaseName: basename(path),
        ext: getFileExtension(path),
      );
    }
  }
}
