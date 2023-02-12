//? file info
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  Map<String, String> toJSON() {
    return {
      parentPathString: parentPath,
      pathString: path,
      modifiedString: modified.toIso8601String(),
      accessedString: accessed.toIso8601String(),
      changedString: changed.toIso8601String(),
      entityTypeString: entityType.name,
      fileBaseNameString: fileBaseName,
      sizeString: size.toString(),
      extString: ext,
    };
  }

  static LocalFileInfo fromJSON(Map<String, dynamic> jsonOBJ) {
    int size = int.parse(jsonOBJ[sizeString]!);
    String parentPath = jsonOBJ[parentPathString]!;
    String path = jsonOBJ[pathString]!;
    DateTime modified = DateTime.parse(jsonOBJ[modifiedString]!);
    DateTime accessed = DateTime.parse(jsonOBJ[accessedString]!);
    DateTime changed = DateTime.parse(jsonOBJ[changedString]!);
    EntityType entityType =
        stringToEnum(jsonOBJ[entityTypeString]!, EntityType.values);
    String fileBaseName = jsonOBJ[fileBaseNameString]!;
    String ext = jsonOBJ[extString]!;
    return LocalFileInfo(
      size: size,
      parentPath: parentPath,
      path: path,
      modified: modified,
      accessed: accessed,
      changed: changed,
      entityType: entityType,
      fileBaseName: fileBaseName,
      ext: ext,
    );
  }

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
}
