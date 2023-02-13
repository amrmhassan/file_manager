//? folder info

import 'package:explorer/models/types.dart';
import 'package:hive/hive.dart';

part 'local_folder_info.g.dart';

@HiveType(typeId: 9)
class LocalFolderInfo {
  @HiveField(0)
  final String parentPath;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final DateTime modified;
  @HiveField(3)
  final DateTime accessed;
  @HiveField(4)
  final DateTime changed;
  @HiveField(5)
  final EntityType entityType;
  @HiveField(6)
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

  // Map<String, String> toJSON() {
  //   return {
  //     pathString: path,
  //     parentPathString: parentPath,
  //     modifiedString: modified.toIso8601String(),
  //     accessedString: accessed.toIso8601String(),
  //     changedString: changed.toIso8601String(),
  //     entityTypeString: entityType.name,
  //     dateCapturedString: dateCaptured.toIso8601String(),
  //     sizeString: size == null ? dbNull : size.toString(),
  //   };
  // }

  // static LocalFolderInfo fromJSON(Map<String, dynamic> jsonOBJ) {
  //   return LocalFolderInfo(
  //     parentPath: jsonOBJ[parentPathString],
  //     path: jsonOBJ[pathString],
  //     modified: DateTime.parse(jsonOBJ[modifiedString]),
  //     accessed: DateTime.parse(jsonOBJ[accessedString]),
  //     changed: DateTime.parse(jsonOBJ[changedString]),
  //     dateCaptured: DateTime.parse(jsonOBJ[dateCapturedString]),
  //     entityType: stringToEnum(jsonOBJ[entityTypeString], EntityType.values),
  //     size: jsonOBJ[sizeString] == dbNull
  //         ? null
  //         : int.parse(jsonOBJ[sizeString]!),
  //   );
  // }

  // static String toSQLString() {
  //   return 'CREATE TABLE $localFolderInfoTableName ($pathString TEXT PRIMARY KEY,$parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $dateCapturedString TEXT, $sizeString TEXT)';
  // }
}
