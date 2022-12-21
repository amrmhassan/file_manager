// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:explorer/constants/styles.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/screens/explorer_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class ChildrenViewList extends StatefulWidget {
  final bool sizesExplorer;

  const ChildrenViewList({
    super.key,
    this.sizesExplorer = false,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList> {
//? to update when path changes
  @override
  void didUpdateWidget(covariant ChildrenViewList oldWidget) {
    // var expProviderFalse =
    //     Provider.of<ExplorerProvider>(context, listen: false);
    // Future.delayed(Duration.zero).then((value) async {
    //   var test = await Provider.of<ExplorerProvider>(context, listen: false)
    //       .viewedChildren(context, widget.sizesExplorer);
    //   setState(() {
    //     fixedEntityList = test;
    //   });
    // });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Future.delayed(Duration(milliseconds: 50)).then((value) {
    //     if (!mounted) return;
    //     //! this is also a very bad implementation to scroll a list
    //     double? scrollPos =
    //         Provider.of<ChildrenItemsProvider>(context, listen: false)
    //             .getScrollingPosition(expProviderFalse.currentActiveDir.path);
    //     if (scrollPos != null) {
    //       try {
    //         scrollController.jumpTo(scrollPos);
    //       } catch (e) {
    //         Future.delayed(Duration(milliseconds: 100)).then((value) {
    //           try {
    //             scrollController.jumpTo(scrollPos);
    //           } catch (e) {
    //             //
    //           }
    //         });
    //       }
    //     }
    //   });
    // });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);

    return expProvider.loadingChildren && expProvider.children.isEmpty
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder(
            future: expProvider.viewedChildren(context, widget.sizesExplorer),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var viewedList = snapshot.data;
                if (viewedList == null) return EmptyFolder();
                return viewedList.isNotEmpty
                    ? EntitiesListViewBuilder(
                        sizesExplorer: widget.sizesExplorer,
                        viewedList: viewedList,
                      )
                    : expProviderFalse.error == null
                        ? (!expProviderFalse.loadingChildren
                            ? EmptyFolder()
                            : SizedBox())
                        : ErrorOpenFolder();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}

//? the list to control
class EntitiesListViewBuilder extends StatefulWidget {
  final List<StorageItemModel> viewedList;
  final bool sizesExplorer;

  const EntitiesListViewBuilder({
    Key? key,
    required this.viewedList,
    required this.sizesExplorer,
  }) : super(key: key);

  @override
  State<EntitiesListViewBuilder> createState() =>
      _EntitiesListViewBuilderState();
}

class _EntitiesListViewBuilderState extends State<EntitiesListViewBuilder> {
  ScrollController scrollController = ScrollController();

//? this will get the scrolling position and update it
  void updateScrollingPosition() {
    String path = Provider.of<ExplorerProvider>(context, listen: false)
        .currentActiveDir
        .path;
    double scrollPosition =
        Provider.of<ChildrenItemsProvider>(context, listen: false)
                .getScrollingPosition(path) ??
            0;
    scrollController.animateTo(scrollPosition,
        duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
  }

  @override
  void initState() {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.removeListener(() {});

      scrollController.addListener(() {
        Provider.of<ChildrenItemsProvider>(context, listen: false)
            .setFolderScroll(
          expProviderFalse.currentActiveDir.path,
          scrollController.offset,
        );
      });
      updateScrollingPosition();
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
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    var analyzerProviderFalse =
        Provider.of<AnalyzerProvider>(context, listen: false);

    return ListView.builder(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      itemCount: widget.viewedList.length,
      itemBuilder: (context, index) {
        StorageItemModel f = widget.viewedList[index];
        return StorageItem(
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
    );
  }
}
