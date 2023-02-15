import 'dart:io';

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
