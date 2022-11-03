// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/screens/home_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/home_screen/widgets/storage_item.dart';

bool prioritizeFolders = true;

class ChildrenViewList extends StatefulWidget {
  final Directory currentActiveDir;
  final Function(FileSystemEntity folder) clickFolder;

  const ChildrenViewList({
    super.key,
    required this.currentActiveDir,
    required this.clickFolder,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList>
    with FilesFoldersOperations {
  List<FileSystemEntity> viewedChildren = [];
  String? error;

  //? update viewed children
  void updateViewChildren() {
    try {
      List<FileSystemEntity> children = getDirectFolderChildern(
        Directory(widget.currentActiveDir.path),
      );
      if (prioritizeFolders) {
        List<FileSystemEntity> folders =
            children.where((element) => isDir(element.path)).toList();
        List<FileSystemEntity> files =
            children.where((element) => isFile(element.path)).toList();
        children = [...folders, ...files];
      }
      setState(() {
        viewedChildren = children;
        error = null;
      });
    } catch (e) {
      setState(() {
        viewedChildren.clear();
        error = e.toString();
      });
    }
  }

//? when widget update
  @override
  void didUpdateWidget(covariant ChildrenViewList oldWidget) {
    if (oldWidget.currentActiveDir != widget.currentActiveDir) {
      updateViewChildren();
    }

    super.didUpdateWidget(oldWidget);
  }

//? when first loading the list
  @override
  void initState() {
    updateViewChildren();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: viewedChildren.isNotEmpty
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: viewedChildren.length,
              itemBuilder: (context, index) {
                FileSystemEntity f = viewedChildren[index];
                return StorageItem(
                  fileSystemEntity: f,
                  onDirTapped: widget.clickFolder,
                );
              },
            )
          : error == null
              ? EmptyFolder()
              : ErrorOpenFolder(),
    );
  }
}
