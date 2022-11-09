//? folder info

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';

class LocalFolderInfo {
  final String parentPath;
  final String path;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final EntityType entityType;
  final DateTime dateCaptured;
  int? size;

  LocalFolderInfo({
    required this.parentPath,
    required this.path,
    required this.modified,
    required this.accessed,
    required this.changed,
    required this.dateCaptured,
    required this.entityType,
    this.size,
  });

  Map<String, String> toJSON() {
    return {
      parentPathString: parentPath,
      pathString: path,
      modifiedString: modified.toIso8601String(),
      accessedString: accessed.toIso8601String(),
      changedString: changed.toIso8601String(),
      entityTypeString: entityType.name,
      dateCapturedString: dateCaptured.toIso8601String(),
      sizeString: size == null ? dbNull : size.toString(),
    };
  }

  static LocalFolderInfo fromJSON(Map<String, String> jsonOBJ) {
    return LocalFolderInfo(
      parentPath: jsonOBJ[parentPathString]!,
      path: jsonOBJ[pathString]!,
      modified: DateTime.parse(jsonOBJ[modifiedString]!),
      accessed: DateTime.parse(jsonOBJ[accessedString]!),
      changed: DateTime.parse(jsonOBJ[changedString]!),
      dateCaptured: DateTime.parse(jsonOBJ[dateCapturedString]!),
      entityType: stringToEnum(jsonOBJ[entityTypeString]!, EntityType.values),
      size: jsonOBJ[sizeString] == dbNull
          ? null
          : int.parse(jsonOBJ[sizeString]!),
    );
  }
}
