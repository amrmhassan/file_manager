import 'dart:io';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:path/path.dart' as path_operations;

//? to copy a file
File copyFile(String path, String dest) {
  File file = File(path);
  if (!file.existsSync()) {
    throw Exception('File $path Does\'nt exist');
  }
  Directory destDir = Directory(dest);
  if (!destDir.existsSync()) {
    throw Exception('Folder $path Does\'nt exist');
  }
  String newPath = '${destDir.path}/${path_operations.basename(file.path)}';
  List<FileSystemEntity> folderChildren = destDir.listSync();
  bool dirContainsItem =
      folderChildren.any((element) => element.path == newPath);
  if (dirContainsItem) {
    newPath =
        '${destDir.path}/${getFileName(path)} - Copy .${getFileExtension(path)}';
    bool dirContainerCopy = folderChildren.any(
      (element) => element.path == newPath,
    );
    if (dirContainerCopy) {
      return copyFile(newPath, dest);
    }
  }
  File newFile;
  try {
    newFile = file.copySync(newPath);
  } catch (e) {
    rethrow;
  }
  return newFile;
}

void deleteFile(String path) {
  File file = File(path);
  if (!file.existsSync()) {
    printOnDebug('File $path Does\'nt exist');
  }
  try {
    file.deleteSync();
  } catch (e) {
    printOnDebug(e);
  }
}
