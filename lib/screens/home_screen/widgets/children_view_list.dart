// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/screens/home_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/home_screen/widgets/storage_item.dart';

class ChildrenViewList extends StatefulWidget {
  final Function(String path) clickFolder;
  final List<FileSystemEntity> viewedChildren;
  final Directory activeDirectory;
  final String? error;
  final bool loading;

  const ChildrenViewList({
    super.key,
    required this.viewedChildren,
    required this.error,
    required this.clickFolder,
    required this.loading,
    required this.activeDirectory,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList>
    with FilesFoldersOperations {
  ScrollController scrollController = ScrollController();
  List<FileSystemEntity> fixedEntityList = [];
  // List<FileSystemEntity> get priotorizedChildren {
  //   print('object');
  //   return [
  //     ...widget.viewedChildren.where((element) => isDir(element.path)).toList(),
  //     ...widget.viewedChildren.where((element) => isFile(element.path)).toList()
  //   ];
  // }

  // @override
  // void initState() {
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //     scrollController.removeListener(() {});

  //     scrollController.addListener(() {
  //       Provider.of<ChildrenItemsProvider>(context, listen: false)
  //           .setFolderScroll(
  //         widget.activeDirectory.path,
  //         scrollController.offset,
  //       );
  //     });
  //   });

  //   super.initState();
  // }

  // @override
  // void didUpdateWidget(covariant ChildrenViewList oldWidget) {
  //   if (oldWidget.activeDirectory != widget.activeDirectory) {
  //     SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
  //       double? offset =
  //           Provider.of<ChildrenItemsProvider>(context, listen: false)
  //               .getScrollingPosition(widget.activeDirectory.path);
  //       if (offset != null) {
  //         scrollController.jumpTo(offset);
  //       }
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    fixedEntityList =
        getFixedEntityList(prioritizeFolders, widget.viewedChildren);
    printOnDebug('****************** Rebuilding children view list');

    return Expanded(
      child: fixedEntityList.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: fixedEntityList.length,
              itemBuilder: (context, index) {
                FileSystemEntity f = fixedEntityList[index];
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
