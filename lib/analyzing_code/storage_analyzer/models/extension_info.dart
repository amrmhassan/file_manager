import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';

class ExtensionInfo {
  final int count;
  final String ext;
  final int size;

  const ExtensionInfo({
    required this.count,
    required this.ext,
    required this.size,
  });

  Map<String, String> toJSON() {
    return {
      countString: count.toString(),
      extString: ext,
      sizeString: size.toString(),
    };
  }

  static ExtensionInfo fromJSON(Map<String, dynamic> jsonOBJ) {
    return ExtensionInfo(
      count: int.parse(jsonOBJ[countString]),
      ext: jsonOBJ[extString],
      size: jsonOBJ[sizeString],
    );
  }

  static String toSQLString() {
    return 'CREATE TABLE $extensionInfoTableName ($extString TEXT PRIMARY KEY,$countString TEXT, $sizeString TEXT)';
  }
}
