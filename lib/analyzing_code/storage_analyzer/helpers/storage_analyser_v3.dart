import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import '../../globals/files_folders_operations.dart';

//! this will have the ability to save the received data to the sqlite with a localFilesInfo table, and a localFoldersInfo table
class StorageAnalyserV3 {
  String parentPath;
  List<String> children;
  List<LocalFileInfo> allFilesInfo;
  List<LocalFolderInfo> allFoldersInfo;
  FolderTreeV2? _folderTreeV2;

  StorageAnalyserV3({
    required this.parentPath,
    required this.children,
    required this.allFilesInfo,
    required this.allFoldersInfo,
  });

  FolderTreeV2? get folderTreeV2 {
    return _folderTreeV2;
  }

  FolderTreeV2 getFolderTreeV2() {
    FolderTreeV2 ft = _analyzeFolder(parentPath);
    _folderTreeV2 = ft;
    return ft;
  }

//! start of the new method
//? this will return all folders info, try to make a compound future to save all folders info to the slqlite and execute it in another method after updating the state
//? to reduce the time of the user waiting
  List<LocalFolderInfo> getFoldersFullInfo(String path) {
    List<LocalFolderInfo> foldersInfoWithSizes = [];

    for (var folderInfo in allFoldersInfo) {
      int folderSize = calculateFolderSize(folderInfo.path);
      folderInfo.size = folderSize;
      foldersInfoWithSizes.add(folderInfo);
    }

    return foldersInfoWithSizes;
  }

  int calculateFolderSize(String path) {
    int size = 0;
    for (var file in allFilesInfo) {
      if (file.parentPath.contains(path)) {
        size += file.size;
      }
    }
    return size;
  }

//! end of the new method

  FolderTreeV2 _analyzeFolder(String path) {
    List<String> directChildren = getFolderDirectChildren(path);
    FolderTreeV2 folderTreeV2 =
        FolderTreeV2(path: path, folderTree: [], files: []);
    for (var directChild in directChildren) {
      bool file = isFile(directChild);
      if (file) {
        //? do file stuff
        LocalFileInfo fileInfo = getFileInfo(directChild);
        folderTreeV2.addFileInfo(fileInfo);
      } else {
        //? do folder stuff
        FolderTreeV2? ft = _analyzeFolder(directChild);
        folderTreeV2.addFolderTree(ft);
      }
    }
    return folderTreeV2;
  }

//? this is a simulation for the dir.listSync()
  List<String> getFolderDirectChildren(String path) {
    List<String> directChildren = [];
    for (var child in children) {
      // child = "sdcard/Songs/Anasheed"
      String remaining = child.replaceAll(path, '');
      var test = remaining.split('/');
      bool directChild =
          test.length == 2 && test.last.isNotEmpty && test.first.isEmpty;
      if (directChild) {
        directChildren.add(child);
      }
    }
    return directChildren;
  }

//? to get the file info from already calculated list of files
  LocalFileInfo getFileInfo(String filePath) {
    return allFilesInfo.firstWhere((element) => element.path == filePath);
  }
}
