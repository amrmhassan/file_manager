// import 'dart:io';

// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:path_provider/path_provider.dart';

// class HiveHelper {
//   final String _boxName;
//   HiveHelper(this._boxName);

//   Future<Box<dynamic>> init() async {
//     Directory docDir = await getApplicationDocumentsDirectory();
//     Hive.init(docDir.path);
//     return await Hive.openBox(_boxName);
//   }
// }
