import 'dart:io';

import 'package:explorer/constants/global_constants.dart';

String _letters = 'abcdefghijklmnopqrstuvwxyz';

List<Directory> _validWindowsDisks() {
  List<Directory> validLetters = [];
  _letters.split('').forEach((letter) {
    Directory dir = Directory('$letter:');
    if (dir.existsSync()) {
      validLetters.add(dir);
    }
  });
  return [...validLetters];
}

Future initialDirsInitForWindows() async {
  //?
  // sdcard setting
  var path = _validWindowsDisks();
  path.insert(0, Directory('/'));
  initialDirs = path.map((e) => e).toList();

  //?
}
