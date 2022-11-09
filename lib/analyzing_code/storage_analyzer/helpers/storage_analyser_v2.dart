import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';

import '../../globals/files_folders_operations.dart';

class StorageAnalyserV2 {
  String parentPath;
  List<String> children;
  List<LocalFileInfo> allFilesInfo;
  FolderTreeV2? _folderTreeV2;
  StorageAnalyserV2(this.parentPath, this.children, this.allFilesInfo);

  FolderTreeV2? get folderTreeV2 {
    return _folderTreeV2;
  }

  FolderTreeV2 getFolderTreeV2() {
    FolderTreeV2 ft = _analyzeFolder(parentPath);
    _folderTreeV2 = ft;
    return ft;
  }

//! test the ability of the addSize method on the folder info class to work by making a list of folders info and add size to one of them
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

// //? to start getting
//   Future<FolderTreeV2> getFolderTreeV2() async {
//     FolderTreeV2 ft = await _analyzeFolder(path);
//     _folderTreeV2 = ft;
//     return ft;
//   }

// //? to analyser a folder
//   Future<FolderTreeV2> _analyzeFolder(String p) async {
//     Directory dir = Directory(p);

//     try {
//       var directChildren = dir.listSync();

//       FolderTreeV2 folderTreeV2 = FolderTreeV2(
//         path: dir.path,
//         folderTreeV2: [],
//         files: [],
//       );
//       for (var directChild in directChildren) {
//         if (isFile(directChild.path)) {
//           int size = (await directChild.stat()).size;
//           FileInfo fileInfo = FileInfo(
//             fileSystemEntity: directChild,
//             size: size,
//           );
//           folderTreeV2.addFileInfo(fileInfo);
//         } else {
//           FolderTreeV2? ft = await _analyzeFolder(directChild.path);
//           folderTreeV2.addFolderTreeV2(ft);
//         }
//       }
//       return folderTreeV2;
//     } catch (e) {
//       FolderTreeV2 folderTreeV2 = FolderTreeV2(
//         path: dir.path,
//         folderTreeV2: [],
//         files: [],
//       );
//       return folderTreeV2;
//     }
//   }
}
