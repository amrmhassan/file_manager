//? Storage Item model
import 'dart:io';

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/models/types.dart';

class StorageItemModel {
  final String parentPath;
  final String path;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final EntityType entityType;
  final int? size;

  StorageItemModel({
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.entityType,
    required this.size,
  });

  Map<String, String> toJSON() {
    return {
      parentPathString: parentPath,
      pathString: path,
      modifiedString: modified.toIso8601String(),
      accessedString: accessed.toIso8601String(),
      changedString: changed.toIso8601String(),
      entityTypeString: entityType.name,
      sizeString: size == null ? dbNull : size.toString(),
    };
  }
}
