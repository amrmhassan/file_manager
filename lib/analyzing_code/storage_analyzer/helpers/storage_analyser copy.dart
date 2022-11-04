// import 'dart:io';

// import 'package:flutter/material.dart';

// import '../../globals/files_folders_operations.dart';
// import '../models/file_info.dart';
// import '../models/folder_tree.dart';

// class StorageAnalyser with FilesFoldersOperations {
//   String path;
//   FolderTree? _folderTree;
//   StorageAnalyser(this.path);

//   FolderTree? get folderTree {
//     return _folderTree;
//   }

// //? to start getting
//   Future<void> getFolderTree(VoidCallback callback) async {
//     await _analyzeFolder(path, callback);
//   }

// //? to analyser a folder
//   Future<void> _analyzeFolder(String p, VoidCallback callback) async {
//     Directory dir = Directory(p);

//     try {
//       FolderTree streamTree = FolderTree(
//         path: dir.path,
//         folderTree: [],
//         files: [],
//       );
//       var stream = dir.list();
//       stream.listen((FileSystemEntity directChild) async {
//         if (isFile(directChild.path)) {
//           int size = (await directChild.stat()).size;
//           FileInfo fileInfo = FileInfo(
//             fileSystemEntity: directChild,
//             size: size,
//           );
//           streamTree.addFileInfo(fileInfo);
//         } else {
//           _analyzeFolder(directChild.path, callback);
//           streamTree.addFolderTree(ft);
//         }
//       });
//     } catch (e) {
//       FolderTree(
//         path: dir.path,
//         folderTree: [],
//         files: [],
//       );
//     }
//   }
// }
