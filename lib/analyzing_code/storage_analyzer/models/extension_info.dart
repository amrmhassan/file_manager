import 'package:explorer/constants/models_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'extension_info.g.dart';

@HiveType(typeId: 10)
class ExtensionInfo {
  @HiveField(0)
  final int count;
  @HiveField(1)
  final String ext;
  @HiveField(2)
  final int size;
  @HiveField(3)
  final List<String> filesPath;

  const ExtensionInfo({
    required this.count,
    required this.ext,
    required this.size,
    required this.filesPath,
  });

  Map<String, String> toJSON() {
    String fp = filesPath.join('++==');
    return {
      countString: count.toString(),
      extString: ext,
      sizeString: size.toString(),
      filesPathString: fp,
    };
  }

  // static ExtensionInfo fromJSON(Map<String, dynamic> jsonOBJ) {
  //   return ExtensionInfo(
  //     count: int.parse(jsonOBJ[countString]),
  //     ext: jsonOBJ[extString],
  //     size: int.parse(jsonOBJ[sizeString]),
  //     filesPath: (jsonOBJ[filesPathString] as String).split('++=='),
  //   );
  // }

  // static String toSQLString() {
  //   return 'CREATE TABLE $extensionInfoTableName ($extString TEXT PRIMARY KEY,$countString TEXT, $sizeString TEXT, $filesPathString TEXT)';
  // }
}
