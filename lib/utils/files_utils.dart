//? check if a the path holds a file
import 'dart:io';

bool isFile(String path) {
  File file = File(path);
  return file.existsSync();
}

//? check if a path holds a folder
bool isDir(String path) {
  Directory dir = Directory(path);
  return dir.existsSync();
}
