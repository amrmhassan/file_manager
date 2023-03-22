// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class EntitiesListViewBuilder extends StatefulWidget {
  final List<StorageItemModel> viewedList;
  final bool sizesExplorer;
  final bool viewFile;

  const EntitiesListViewBuilder({
    Key? key,
    required this.viewedList,
    required this.sizesExplorer,
    required this.viewFile,
  }) : super(key: key);

  @override
  State<EntitiesListViewBuilder> createState() =>
      _EntitiesListViewBuilderState();
}

class _EntitiesListViewBuilderState extends State<EntitiesListViewBuilder> {
  ScrollController scrollController = ScrollController();
  double? eachItemHeight;
  String? viewedFilePath;

//? this will get the scrolling position and update it
  void updateScrollingPosition() {
    String path = Provider.of<ExplorerProvider>(context, listen: false)
        .currentActiveDir
        .path;
    double scrollPosition =
        Provider.of<ChildrenItemsProvider>(context, listen: false)
                .getScrollingPosition(path) ??
            0;
    // scrollController.animateTo(scrollPosition,
    //     duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
    scrollController.jumpTo(scrollPosition);
  }

  void scrollToFile(ExplorerProvider explorerProviderFalse) {
    double fullListHeight = scrollController.position.viewportDimension +
        scrollController.position.maxScrollExtent;
    int index = widget.viewedList.indexWhere(
        (element) => element.path == explorerProviderFalse.viewedFilePath);
    setState(() {
      eachItemHeight = fullListHeight / widget.viewedList.length;
      viewedFilePath = explorerProviderFalse.viewedFilePath;
    });
    scrollController.jumpTo(index * eachItemHeight!);
    explorerProviderFalse.setViewedFilePath(null);
  }

  @override
  void initState() {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      scrollController.removeListener(() {});

      scrollController.addListener(() {
        Provider.of<ChildrenItemsProvider>(context, listen: false)
            .setFolderScroll(
          expProviderFalse.currentActiveDir.path,
          scrollController.offset,
        );
      });
      if (expProviderFalse.viewedFilePath == null) {
        updateScrollingPosition();
      } else {
        scrollToFile(expProviderFalse);
      }
    });

    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant EntitiesListViewBuilder oldWidget) {
  //   print('update widget');
  //   updateScrollingPosition();
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    var analyzerProviderFalse =
        Provider.of<AnalyzerProvider>(context, listen: false);

    return DraggableScrollbar.semicircle(
      backgroundColor: kCardBackgroundColor,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: widget.viewedList.length,
        itemBuilder: (context, index) {
          StorageItemModel f = widget.viewedList[index];
          return StorageItem(
            viewedFilePath: viewedFilePath,
            allowShowingFavIcon: true,
            key: Key(f.path),
            storageItemModel: f,
            onDirTapped: (path) {
              var foProvider = Provider.of<FilesOperationsProvider>(
                context,
                listen: false,
              );
              expProviderFalse.setActiveDir(
                path: path,
                sizesExplorer: widget.sizesExplorer,
                analyzerProvider: analyzerProviderFalse,
                filesOperationsProvider: foProvider,
              );
            },
            sizesExplorer: widget.sizesExplorer,
            parentSize: expProvider.parentSize ?? 0,
          );
        },
      ),
    );
  }
}
