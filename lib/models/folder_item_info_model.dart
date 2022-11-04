import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';

class FolderItemInfoModel {
  final String path;
  final String name;
  // final List<String> directChildren;
  // final int scrollingTo;
  int? itemCount;
  DateTime dateCaptured;
  int? size;

  FolderItemInfoModel({
    required this.path,
    required this.name,
    // required this.directChildren,
    // this.scrollingTo = 0,
    this.itemCount,
    required this.dateCaptured,
    this.size,
  });

  Map<String, dynamic> toJSON() {
    return {
      pathString: path,
      nameString: name,
      // directChildrenString: directChildren.toString(),
      // scrollingToString: scrollingTo.toString(),
      itemCountString: itemCount ?? dbNull,
      sizeString: size ?? dbNull,
      dateCapturedString: dateCaptured.toIso8601String(),
    };
  }

  static FolderItemInfoModel fromJSON(Map<String, dynamic> jsonObj) {
    // List<String> directChildren =
    //     (jsonDecode(jsonObj[directChildrenString] as String) as List<dynamic>)
    // .map((e) => e.toString())
    // .toList();
    // int scrollingTo = int.parse((jsonObj[scrollingToString] as String));
    String name = jsonObj[nameString];
    String path = jsonObj[pathString];
    int? itemCount = jsonObj[itemCountString] == dbNull
        ? null
        : int.parse(jsonObj[itemCountString]);
    int? size =
        jsonObj[sizeString] == dbNull ? null : int.parse(jsonObj[sizeString]);
    DateTime dateCaptured = DateTime.parse(jsonObj[dateCapturedString]);
    return FolderItemInfoModel(
      // directChildren: directChildren,
      // scrollingTo: scrollingTo,
      name: name,
      path: path,
      itemCount: itemCount,
      size: size,
      dateCaptured: dateCaptured,
    );
  }

  static String toSQLString() {
    return 'CREATE TABLE $folderInfoTableName ($pathString TEXT PRIMARY KEY,$nameString TEXT,$itemCountString TEXT,$sizeString TEXT, $dateCapturedString TEXT)';
  }
}
