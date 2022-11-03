// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/analyzing_code/explorer_utils/scanning_utils.dart';
import 'package:explorer/screens/home_screen/widgets/file_item.dart';
import 'package:flutter/material.dart';

class ChildrenViewList extends StatelessWidget {
  final Directory currentActiveDir;
  final Function(FileSystemEntity folder) clickFolder;

  const ChildrenViewList({
    super.key,
    required this.currentActiveDir,
    required this.clickFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ...ScanningUtils()
              .getDirectFolderChildern(
                Directory(currentActiveDir.path),
              )
              .map(
                (e) => StorageItem(
                  fileSystemEntity: e,
                  onDirTapped: clickFolder,
                ),
              ),
        ],
      ),
    );
  }
}
