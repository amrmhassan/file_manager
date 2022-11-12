import 'dart:io';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:path/path.dart' as path_operations;

//? to copy a file
File copyFile(String filePath, String destDirPath) {
  File file = File(filePath);
  if (!file.existsSync()) {
    throw Exception('File $filePath Does\'nt exist');
  }
  Directory destDir = Directory(destDirPath);
  if (!destDir.existsSync()) {
    throw Exception('Folder $filePath Does\'nt exist');
  }
  String newPath = '${destDir.path}/${path_operations.basename(file.path)}';
  List<FileSystemEntity> folderChildren = destDir.listSync();
  bool dirContainsItem =
      folderChildren.any((element) => element.path == newPath);
  if (dirContainsItem) {
    newPath =
        '${destDir.path}/${getFileName(filePath)} - Copy .${getFileExtension(filePath)}';
    bool dirContainerCopy = folderChildren.any(
      (element) => element.path == newPath,
    );
    if (dirContainerCopy) {
      return copyFile(newPath, destDirPath);
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

//? to delete a file
void deleteFile(String filePath) {
  File file = File(filePath);
  if (!file.existsSync()) {
    printOnDebug('File $filePath Does\'nt exist');
  }
  try {
    file.deleteSync();
  } catch (e) {
    printOnDebug(e);
  }
}

//? to copy a folder
void copyFolder(
  String folderPath,
  String destPath,
) {
  //* name of the folder that will be copied
  String targetFolderName = path_operations.basename(folderPath);
  //* the path of the future folder that will be copied later
  String targetFolderPath = '$destPath/$targetFolderName';
  //* the original target directory that needs to be copied
  Directory originalTargetDir = Directory(folderPath);
  //* target folder that will be created from the original folder
  Directory targetFolder = Directory(targetFolderPath);
  //* all children of the original dir
  var allChildren = originalTargetDir.listSync(recursive: true);
  //* creating the target folder that will hold all copied folders, files
  targetFolder.createSync();
  for (var child in allChildren) {
    if (child.statSync().type == FileSystemEntityType.directory) {
      Directory newDir = Directory(
          child.path.replaceAll(originalTargetDir.path, targetFolderPath));
      newDir.createSync();
    } else {
      File(child.path).copySync(
          child.path.replaceAll(originalTargetDir.path, targetFolderPath));
    }
  }
}

//? to delete a folder
void deleteFolder(String folderPath) {
  try {
    Directory(folderPath).deleteSync(recursive: true);
  } catch (e) {
    rethrow;
  }
}
