import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:external_path/external_path.dart';

Future initialDirsInit() async {
  //?
  // sdcard setting
  var path = await ExternalPath.getExternalStorageDirectories();
  path.insert(0, '/');
  initialDirs = path.map((e) => Directory(e)).toList();

  //?
}

void initMainDisksCustomInfo() {
  //? handle main disks custom name
  for (var disk in explorerMainDisks) {
    if (disk.path.endsWith('0')) {
      mainDisksMapper[disk.path] = 'Internal Storage';
      disk.customThumbnail = 'assets/icons/phone.png';
      disk.hideDate = true;
    } else {
      mainDisksMapper[disk.path] = 'SD Card';
      disk.customThumbnail = 'assets/icons/sd-card.png';
      disk.hideDate = true;
    }
  }
}
