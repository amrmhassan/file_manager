//? Storage Item model
import 'dart:io';

class StorageItemModel {
  final String parentPath;
  final String path;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final FileSystemEntityType fileSystemEntityType;
  final int? size;

  StorageItemModel({
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.fileSystemEntityType,
    required this.size,
  });
}
