// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/dir_children_list_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/screen_utils/children_view_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:explorer/screens/explorer_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ChildrenViewList extends StatefulWidget {
  final bool sizesExplorer;
  final int? parentSize;

  const ChildrenViewList({
    super.key,
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

  @override
  void initState() {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    // Future.delayed(Duration.zero).then((value) async {
    //   var test =
    //       await expProviderFalse.viewedChildren(context, widget.sizesExplorer);
    //   printOnDebug('from initstate ${test.length}');
    //   setState(() {
    //     fixedEntityList = test;
    //   });
    // });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.removeListener(() {});

      scrollController.addListener(() {
        Provider.of<ChildrenItemsProvider>(context, listen: false)
            .setFolderScroll(
          expProviderFalse.currentActiveDir.path,
          scrollController.offset,
        );
      });
    });

    super.initState();
  }

//? to update when path changes
  @override
  void didUpdateWidget(covariant ChildrenViewList oldWidget) {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    // Future.delayed(Duration.zero).then((value) async {
    //   var test = await Provider.of<ExplorerProvider>(context, listen: false)
    //       .viewedChildren(context, widget.sizesExplorer);
    //   printOnDebug('from did update ${test.length}');
    //   setState(() {
    //     fixedEntityList = test;
    //   });
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 50)).then((value) {
        //! this is also a very bad implementation to scroll a list
        double? scrollPos =
            Provider.of<ChildrenItemsProvider>(context, listen: false)
                .getScrollingPosition(expProviderFalse.currentActiveDir.path);
        if (scrollPos != null) {
          try {
            scrollController.jumpTo(scrollPos);
          } catch (e) {
            Future.delayed(Duration(milliseconds: 100)).then((value) {
              try {
                scrollController.jumpTo(scrollPos);
              } catch (e) {
                printOnDebug('Error with auto scroll list');
              }
            });
          }
        }
      });
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    return expProvider.loadingChildren
        ? SizedBox()
        : FutureBuilder(
            future: expProvider.viewedChildren(context, widget.sizesExplorer),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var viewedList = snapshot.data;
                if (viewedList == null) return EmptyFolder();
                return viewedList.isNotEmpty
                    ? ListView.builder(
                        // controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: viewedList.length,
                        itemBuilder: (context, index) {
                          StorageItemModel f = viewedList[index];
                          return StorageItem(
                            key: Key(f.path),
                            storageItemModel: f,
                            onDirTapped: expProviderFalse.setActiveDir,
                            sizesExplorer: widget.sizesExplorer,
                            parentSize: widget.parentSize ?? 0,
                          );
                        },
                      )
                    : expProviderFalse.error == null
                        ? (!expProviderFalse.loadingChildren
                            ? EmptyFolder()
                            : SizedBox())
                        : ErrorOpenFolder();
              } else {
                return Text('Loading.......');
              }
            },
          );
  }
}
