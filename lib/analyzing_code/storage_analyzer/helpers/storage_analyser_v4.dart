import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_profile.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';

class StorageAnalyserV4 {
  String parentPath;
  List<String> children;
  List<LocalFileInfo> allFilesInfo;
  List<LocalFolderInfo> allFoldersInfo;
  List<LocalFolderInfo> allFolderInfoWithSize = [];
  List<ExtensionInfo> allExtensionsInfo = [];

  StorageAnalyserV4({
    required this.parentPath,
    required this.children,
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
    List<ExtensionProfile?> extesntionsWithRepeat = [];

    List<LocalFileInfo> files = allFilesInfo;
    for (var fileInfo in files) {
      String ext = getFileExtension(fileInfo.path);
      ExtensionProfile ep = ExtensionProfile(ext: ext, localFileInfo: fileInfo);
      extesntionsWithRepeat.add(ep);
    }
    extesntionsWithRepeat.sort(
      (a, b) {
        return a!.ext.compareTo(b!.ext);
      },
    );
    extesntionsWithRepeat.add(null);
    List<ExtensionInfo> extInfoList = [];
    List<String> iterateExt = [];
    int count = 0;
    int extSize = 0;
    ExtensionProfile? previousValue = extesntionsWithRepeat[0];
    for (var ext in extesntionsWithRepeat) {
      if (previousValue?.ext != ext?.ext) {
        iterateExt.add(previousValue!.ext);
        ExtensionInfo ec = ExtensionInfo(
          count: count,
          ext: previousValue.ext,
          size: extSize,
        );
        extInfoList.add(ec);
        extSize = ext?.localFileInfo.size ?? 0;
        count = 1;
      } else if (ext != null) {
        extSize += ext.localFileInfo.size;
        count++;
      }
      previousValue = ext;
    }
    return extInfoList;
  }
}
