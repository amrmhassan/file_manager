// ignore_for_file: overridden_fields

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';

class StorageAnalyzerV4 {
  String parentPath;
  List<LocalFileInfo> allFilesInfo;
  List<LocalFolderInfo> allFoldersInfo;
  List<LocalFolderInfo> allFolderInfoWithSize = [];
  List<ExtensionInfo> allExtensionsInfo = [];

  StorageAnalyzerV4({
    required this.parentPath,
    required this.allFilesInfo,
    required this.allFoldersInfo,
  });

//? to start analyzing
  void run() {
    List<LocalFolderInfo> lfi = _getFoldersFullInfo();
    allFolderInfoWithSize = lfi;
    List<ExtensionInfo> ei = _folderExtensionsInfo();
    allExtensionsInfo = ei;
  }

//? to get all folders info with sizes
  List<LocalFolderInfo> _getFoldersFullInfo() {
    List<LocalFolderInfo> foldersInfoWithSizes = [];

    for (var folderInfo in allFoldersInfo) {
      int folderSize = _calculateFolderSize(folderInfo.path);
      folderInfo.size = folderSize;
      foldersInfoWithSizes.add(folderInfo);
    }

    return foldersInfoWithSizes;
  }

//? to calculate folder size by looping on the whole files info list to calculate the folder size ==> here you can use an algorithm to reduce the number of loops cause it is (XY) BIG(O)
  int _calculateFolderSize(String path) {
    int size = 0;
    for (var file in allFilesInfo) {
      if (file.parentPath.contains(path)) {
        size += file.size;
      }
    }
    return size;
  }

  //? to get all extensions info of a folder
  List<ExtensionInfo> _folderExtensionsInfo() {
    List<LocalFileInfo?> allFiles = [...allFilesInfo];

    allFiles.sort(
      (a, b) {
        return a!.ext.compareTo(b!.ext);
      },
    );
    allFiles.add(null);
    List<ExtensionInfo> extInfoList = [];
    List<String> iterateExt = [];
    List<String> filesPaths = [];
    int count = 0;
    int extSize = 0;
    LocalFileInfo? previousValue = allFiles[0];
    for (var file in allFiles) {
      if (previousValue?.ext != file?.ext) {
        iterateExt.add(previousValue!.ext);
        ExtensionInfo ec = ExtensionInfo(
          count: count,
          ext: previousValue.ext,
          size: extSize,
          filesPath: [...filesPaths],
        );
        extInfoList.add(ec);
        filesPaths.clear();
        extSize = file?.size ?? 0;
        count = 1;
      } else if (file != null) {
        extSize += file.size;
        count++;
        filesPaths.add(file.path);
      }
      previousValue = file;
    }
    return extInfoList;
  }
}

// class StorageAnalyzerV4Creator extends StorageAnalyzerV4 {
//   @override
//   final List<LocalFolderInfo> allFolderInfoWithSize;
//   @override
//   final List<ExtensionInfo> allExtensionsInfo;
//   StorageAnalyzerV4Creator({
//     required super.parentPath,
//     required super.allFilesInfo,
//     required super.allFoldersInfo,
//     required this.allExtensionsInfo,
//     required this.allFolderInfoWithSize,
//   });
// }
