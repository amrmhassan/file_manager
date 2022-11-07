import 'dart:io';

import 'package:path/path.dart' as path;

//? to get all direct folder children
List<FileSystemEntity> getDirectFolderChildern(String path) {
  Directory directory = Directory(path);
  var data = directory.listSync();
  return data.map((e) => e).toList();
}

//? get file size
// Future<int> getFileSize(FileSystemEntity fileSystemEntity) async {
//   return (await fileSystemEntity.stat()).size;
// }

List<String> _fileNameInfo(String p) {
  String baseName = path.basename(p);
  String ext = path.extension(p);
  baseName = baseName.replaceAll(ext, '');
  return [baseName, ext.replaceAll('.', '')];
}

//? to get a file extension
String getFileExtension(String filePath) {
  return _fileNameInfo(filePath).last;
}

//? to get a file name
String getFileName(String filePath) {
  return _fileNameInfo(filePath).first;
}

//? get folder files children
List<String> getChildrenFiles(String path, List<String> filesTypes) {
  List<String> files = [];

  List<FileSystemEntity> folderChildren = getDirectFolderChildern(path);
  for (var child in folderChildren) {
    if (isFile(child.path)) {
      String ext = getFileExtension(child.path);
      if (filesTypes.contains(ext) || filesTypes.isEmpty) {
        files.add(child.path);
      }
    } else {
      List<String> subChildren = getChildrenFiles(child.path, filesTypes);
      files.addAll(subChildren);
    }
  }
  return files;
}

//? get all folder children
List<FileSystemEntity> getRecrusiveFolderChildren(String path) {
  List<FileSystemEntity> folderChildren = getDirectFolderChildern(path);
  List<FileSystemEntity> children = [];
  for (var child in folderChildren) {
    if (isFile(child.path)) {
      children.add(child);
    } else {
      List<FileSystemEntity> subChildren = getDirectFolderChildern(child.path);
      children.add(child);
      children.addAll(subChildren);
    }
  }
  return children;
}

//? check if a the path holds a file
bool isFile(String path) {
  File file = File(path);
  return file.existsSync();
}

//? check if a path holds a folder
bool isDir(String path) {
  Directory dir = Directory(path);
  return dir.existsSync();
}

//? check comment line
bool isCommentLine(String line) {
  if (line.startsWith('//')) {
    return true;
  }
  return false;
}

//? check real line
bool isRealLine(String line) {
  if (line.length > 2 && !isCommentLine(line)) {
    return true;
  }
  return false;
}

//? to get a list of file lines of strings
Future<List<String>> getFileLines(String path) async {
  File file = File(path);
  List<String> allFileLines = await file.readAsLines();
  return allFileLines;
}
