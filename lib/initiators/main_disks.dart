import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:external_path/external_path.dart';

Future mainDisksInit() async {
  //?
  // sdcard setting
  var path = await ExternalPath.getExternalStorageDirectories();
  path.insert(0, '/');
  initialDirs = path.map((e) => Directory(e)).toList();

  //?
}
