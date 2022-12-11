import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/models/types.dart';
import 'package:path/path.dart' as path_operations;

//? this will hold the data of a folder or a file to be viewed in the explorer
class StorageItemModel {
  final String parentPath;
  final String path;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final EntityType entityType;
  int? size;

  StorageItemModel({
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.entityType,
    required this.size,
  });

  LocalFileInfo toLocalFileInfo() {
    return LocalFileInfo(
      size: size!,
      parentPath: parentPath,
      path: path,
      modified: modified,
      accessed: accessed,
      changed: changed,
      entityType: entityType,
      fileBaseName: path_operations.basename(path),
      ext: getFileExtension(path),
    );
  }

  // Map<String, String> toJSON() {
  //   return {
  //     parentPathString: parentPath,
  //     pathString: path,
  //     modifiedString: modified.toIso8601String(),
  //     accessedString: accessed.toIso8601String(),
  //     changedString: changed.toIso8601String(),
  //     entityTypeString: entityType.name,
  //     sizeString: size == null ? dbNull : size.toString(),
  //   };
  // }
}
