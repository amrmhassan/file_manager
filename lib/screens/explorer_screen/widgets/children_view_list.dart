// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:explorer/screens/explorer_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ChildrenViewList extends StatefulWidget {
  final Function(String path) clickFolder;
  final List<StorageItemModel> viewedChildren;
  final Directory activeDirectory;
  final String? error;
  final bool loading;
  final bool sizesExplorer;
  final int? parentSize;

  const ChildrenViewList({
    super.key,
    required this.viewedChildren,
    required this.error,
    required this.clickFolder,
    required this.loading,
    required this.activeDirectory,
    this.sizesExplorer = false,
    this.parentSize,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList> {
  ScrollController scrollController = ScrollController();
  List<StorageItemModel> fixedEntityList = [];

//? this will arrange the children with size if the size explorer is true
  Future<void> handleViewLisChildren() async {
    if (widget.sizesExplorer) {
      List<StorageItemModel> items = [];

      for (var i = 0; i < widget.viewedChildren.length; i++) {
        StorageItemModel child = widget.viewedChildren[i];
        int? entitySize;
        if (child.entityType == EntityType.folder) {
          LocalFolderInfo? localFolderInfo =
              await Provider.of<AnalyzerProvider>(context, listen: false)
                  .getDirInfoByPath(child.path);
          if (localFolderInfo != null) {
            entitySize = localFolderInfo.size ?? 0;
          }
        } else {
          FileStat fileStat = await File(child.path).stat();
          entitySize = fileStat.size;
        }
        StorageItemModel updatedStoraItemModel = StorageItemModel(
          parentPath: child.parentPath,
          path: child.path,
          modified: child.modified,
          accessed: child.accessed,
          changed: child.changed,
          entityType: child.entityType,
          size: entitySize,
        );
        items.add(updatedStoraItemModel);
      }
      items.sort(
        (a, b) => (b.size ?? 0).compareTo(a.size ?? 0),
      );
      setState(() {
        fixedEntityList = items;
      });
    } else {
      setState(() {
        fixedEntityList = getFixedEntityList(widget.viewedChildren);
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      handleViewLisChildren();
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.removeListener(() {});

      scrollController.addListener(() {
        Provider.of<ChildrenItemsProvider>(context, listen: false)
            .setFolderScroll(
          widget.activeDirectory.path,
          scrollController.offset,
        );
      });
    });

    super.initState();
  }

//? to update when path changes
  @override
  void didUpdateWidget(covariant ChildrenViewList oldWidget) {
    handleViewLisChildren();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 50)).then((value) {
        //! this is also a very bad implementation to scroll a list
        if (oldWidget.activeDirectory.path != widget.activeDirectory.path) {
          double? scrollPos =
              Provider.of<ChildrenItemsProvider>(context, listen: false)
                  .getScrollingPosition(widget.activeDirectory.path);
          if (scrollPos != null) {
            try {
              scrollController.jumpTo(scrollPos);
            } catch (e) {
              Future.delayed(Duration(milliseconds: 100)).then((value) {
                scrollController.jumpTo(scrollPos);
              });
            }
          }
        }
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? SizedBox()
        : fixedEntityList.isNotEmpty
            ? ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemCount: fixedEntityList.length,
                itemBuilder: (context, index) {
                  StorageItemModel f = fixedEntityList[index];
                  return StorageItem(
                    key: Key(f.path),
                    storageItemModel: f,
                    onDirTapped: widget.clickFolder,
                    sizesExplorer: widget.sizesExplorer,
                    parentSize: widget.parentSize ?? 0,
                  );
                },
              )
            : widget.error == null
                ? (!widget.loading ? EmptyFolder() : SizedBox())
                : ErrorOpenFolder();
  }
}
