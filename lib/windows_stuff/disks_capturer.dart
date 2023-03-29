import 'dart:io';

import 'package:explorer/constants/global_constants.dart';

String _letters = 'abcdefghijklmnopqrstuvwxyz';

List<Directory> validWindowsDisks() {
  Directory rootDir = Directory('/');
  List<Directory> validLetters = [];
  _letters.split('').forEach((letter) {
    Directory dir = Directory('$letter:');
    if (dir.existsSync()) {
      validLetters.add(dir);
    }
  });
  return [rootDir, ...validLetters];
}

Future initialDirsInitForWindows() async {
  //?
  // sdcard setting
  var path = validWindowsDisks();
  path.insert(0, Directory('/'));
  initialDirs = path.map((e) => e).toList();

  //?
}
