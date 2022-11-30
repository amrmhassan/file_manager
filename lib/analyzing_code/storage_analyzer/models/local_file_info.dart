//? file info
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

class LocalFileInfo {
  final String path;
  final String parentPath;
  final DateTime modified;
  final DateTime accessed;
  final DateTime changed;
  final EntityType entityType;
  final String fileBaseName;
  final String ext;
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
