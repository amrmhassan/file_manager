// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/home_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/home_screen/widgets/child_item_directory.dart';
import 'package:explorer/screens/home_screen/widgets/home_item_h_line.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class StorageItem extends StatelessWidget with FilesFoldersOperations {
  final FileSystemEntity fileSystemEntity;
  final Function(String path) onDirTapped;
  const StorageItem({
    super.key,
    required this.fileSystemEntity,
    required this.onDirTapped,
  });

  bool get isEntitiyDir {
    return isDir(fileSystemEntity.path);
  }

  List<String> fileNameInfo() {
    String p = fileSystemEntity.path;
    String baseName = path.basename(p);
    String ext = path.extension(p);
    baseName = baseName.replaceAll(ext, '');
    return [baseName, ext.replaceAll('.', '')];
  }

  String folderName() {
    return path.basename(fileSystemEntity.path);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () {
        if (isEntitiyDir) {
          onDirTapped(fileSystemEntity.path);
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
                    fileSystemEntity: fileSystemEntity,
                  )
                : ChildFileItem(
                    fileName: fileNameInfo(),
                    fileSystemEntityInfo: fileSystemEntity,
                  ),
          ),
          VSpace(factor: .5),
          HomeItemHLine(),
        ],
      ),
    );
  }
}
