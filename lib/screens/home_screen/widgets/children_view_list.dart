// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/screens/home_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/home_screen/widgets/storage_item.dart';

bool prioritizeFolders = true;

class ChildrenViewList extends StatefulWidget {
  final Function(FileSystemEntity folder) clickFolder;
  final List<FileSystemEntity> viewedChildren;
  final String? error;
  final bool loading;

  const ChildrenViewList({
    super.key,
    required this.viewedChildren,
    required this.error,
    required this.clickFolder,
    required this.loading,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList>
    with FilesFoldersOperations {
  // List<FileSystemEntity> get priotorizedChildren {
  //   print('object');
  //   return [
  //     ...widget.viewedChildren.where((element) => isDir(element.path)).toList(),
  //     ...widget.viewedChildren.where((element) => isFile(element.path)).toList()
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.viewedChildren.isNotEmpty
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.viewedChildren.length,
              itemBuilder: (context, index) {
                FileSystemEntity f = widget.viewedChildren[index];
                return StorageItem(
                  fileSystemEntity: f,
                  onDirTapped: widget.clickFolder,
                );
              },
            )
          : widget.error == null
              ? (!widget.loading ? EmptyFolder() : SizedBox())
              : ErrorOpenFolder(),
    );
  }
}
