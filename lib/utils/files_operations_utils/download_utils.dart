import 'dart:io';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';

//? when downloading a file this function will return the download folder path
String getSaveFilePath(FileType fileType, String fileName) {
  late String downloadFolder;
  switch (fileType) {
    case FileType.apk:
      downloadFolder = _folderPathCheck(apkDownloadFolder);
      break;
    case FileType.archive:
      downloadFolder = _folderPathCheck(archiveDownloadFolder);
      break;
    case FileType.audio:
      downloadFolder = _folderPathCheck(audioDownloadFolder);
      break;
    case FileType.docs:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    case FileType.image:
      downloadFolder = _folderPathCheck(imageDownloadFolder);
      break;
    case FileType.video:
      downloadFolder = _folderPathCheck(videoDownloadFolder);
      break;
    case FileType.excel:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    case FileType.word:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    case FileType.powerPoint:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    case FileType.text:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    case FileType.batch:
      downloadFolder = _folderPathCheck(docDownloadFolder);
      break;
    default:
      downloadFolder = _folderPathCheck(otherDownloadFolder);
      break;
  }
  return '$downloadFolder/$fileName'.replaceAll('//', '/');
}

//? for checking each sub download folder
String _folderPathCheck(String folderName) {
  String mainDownloadPath = _checkMainDownloadFolder();
  Directory directory = Directory('$mainDownloadPath/$folderName');
  if (!directory.existsSync()) {
    directory.createSync();
  }
  return directory.path;
}

//? for checking the main download folder
String _checkMainDownloadFolder() {
  String mainPath = 'sdcard/$mainDownloadFolder';
  Directory mainDir = Directory(mainPath);
  if (!mainDir.existsSync()) {
    mainDir.createSync();
  }
  return mainPath;
}
