// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/home_screen/isolates/load_folder_children_isolates.dart';
import 'package:explorer/screens/home_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/home_screen/widgets/child_item_directory.dart';
import 'package:explorer/screens/home_screen/widgets/home_item_h_line.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class StorageItem extends StatelessWidget with FilesFoldersOperations {
  final FileSystemEntityInfo fileSystemEntityInfo;
  final Function(FileSystemEntity f) onDirTapped;
  const StorageItem({
    super.key,
    required this.fileSystemEntityInfo,
    required this.onDirTapped,
  });

  bool get isEntitiyDir {
    return isDir(fileSystemEntityInfo.fileSystemEntity.path);
  }

  List<String> fileNameInfo() {
    String p = fileSystemEntityInfo.fileSystemEntity.path;
    String baseName = path.basename(p);
    String ext = path.extension(p);
    baseName = baseName.replaceAll(ext, '');
    return [baseName, ext.replaceAll('.', '')];
  }

  String folderName() {
    return path.basename(fileSystemEntityInfo.fileSystemEntity.path);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () {
        if (isEntitiyDir) {
          onDirTapped(fileSystemEntityInfo.fileSystemEntity);
        }
      },
      borderRadius: 0,
      child: Column(
        children: [
          VSpace(factor: .5),
          PaddingWrapper(
            child: isEntitiyDir
                ? ChildDirectoryItem(
                    fileName: folderName(),
                    fileSystemEntity: fileSystemEntityInfo.fileSystemEntity,
                  )
                : ChildFileItem(
                    fileName: fileNameInfo(),
                    fileSystemEntityInfo: fileSystemEntityInfo,
                  ),
          ),
          VSpace(factor: .5),
          HomeItemHLine(),
        ],
      ),
    );
  }
}
