// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerScreen extends StatefulWidget {
  final Function(String path) clickFolder;
  final List<StorageItemModel> viewedChildren;
  final Directory activeDirectory;
  final String? error;
  final bool loading;
  final Directory currentActiveDir;
  final VoidCallback goHome;
  final Function(String path) updateActivePath;
  final bool sizesExplorer;

  const ExplorerScreen({
    super.key,
    required this.clickFolder,
    required this.viewedChildren,
    required this.activeDirectory,
    this.error,
    required this.loading,
    required this.currentActiveDir,
    required this.goHome,
    required this.updateActivePath,
    this.sizesExplorer = false,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  int? parentSize;

  void updateParentSize() {
    Future.delayed(Duration.zero).then((value) async {
      //? here i will update the current active dir size
      LocalFolderInfo? localFolderInfo =
          await Provider.of<AnalyzerProvider>(context, listen: false)
              .getDirInfoByPath(widget.activeDirectory.path);
      if (localFolderInfo != null && localFolderInfo.size != null) {
        setState(() {
          parentSize = localFolderInfo.size;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ExplorerScreen oldWidget) {
    if (oldWidget.activeDirectory.path != widget.activeDirectory.path) {
      updateParentSize();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    updateParentSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeItemHLine(),
        CurrentPathViewer(
          currentActiveDir: widget.currentActiveDir,
          goHome: widget.goHome,
          clickFolder: widget.updateActivePath,
        ),
        HomeItemHLine(),
        VSpace(factor: .5),
        if (widget.sizesExplorer && parentSize == null)
          Expanded(
            child: Center(
              child: Text(
                'Loading',
                style: h4TextStyleInactive,
              ),
            ),
          )
        else
          Expanded(
            child: ChildrenViewList(
              clickFolder: widget.updateActivePath,
              viewedChildren: widget.viewedChildren,
              error: widget.error,
              loading: widget.loading,
              activeDirectory: widget.currentActiveDir,
              //! remove this , it is only for testing UI
              sizesExplorer: widget.sizesExplorer,
              parentSize: parentSize,
            ),
          ),
      ],
    );
  }
}
