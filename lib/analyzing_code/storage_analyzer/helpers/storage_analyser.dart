import 'dart:io';

import '../../globals/files_folders_operations.dart';
import '../models/file_info.dart';
import '../models/folder_tree.dart';

class StorageAnalyser with FilesFoldersOperations {
  String path;
  FolderTree? _folderTree;
  StorageAnalyser(this.path);

  FolderTree? get folderTree {
    return _folderTree;
  }

//? to start getting
  Future<FolderTree> getFolderTree() async {
    FolderTree ft = await _analyzeFolder(path);
    _folderTree = ft;
    return ft;
  }

//? to analyser a folder
  Future<FolderTree> _analyzeFolder(String p) async {
    Directory dir = Directory(p);

    try {
      var directChildren = dir.listSync();

      FolderTree folderTree = FolderTree(
        path: dir.path,
        folderTree: [],
        files: [],
      );
      for (var directChild in directChildren) {
        if (isFile(directChild.path)) {
          int size = (await directChild.stat()).size;
          FileInfo fileInfo = FileInfo(
            fileSystemEntity: directChild,
            size: size,
          );
          folderTree.addFileInfo(fileInfo);
        } else {
          FolderTree? ft = await _analyzeFolder(directChild.path);
          folderTree.addFolderTree(ft);
        }
      }
      return folderTree;
    } catch (e) {
      FolderTree folderTree = FolderTree(
        path: dir.path,
        folderTree: [],
        files: [],
      );
      return folderTree;
    }
  }
}
