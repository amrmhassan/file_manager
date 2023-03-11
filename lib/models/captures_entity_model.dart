import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';

class CapturedEntityModel {
  final String path;
  final EntityType entityType;
  final int size;

  const CapturedEntityModel(
    this.path,
    this.entityType,
    this.size,
  );

  @override
  String toString() {
    return '$entityType => $path';
  }

  static CapturedEntityModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return CapturedEntityModel(
      jsonOBJ[pathString],
      stringToEnum(
        jsonOBJ[entityTypeString],
        EntityType.values,
      ),
      int.tryParse(jsonOBJ[sizeString]) ?? 0,
    );
  }

  Map<String, String> toJSON() {
    return {
      pathString: path,
      entityTypeString: entityType.name,
      sizeString: size.toString(),
    };
  }
}
