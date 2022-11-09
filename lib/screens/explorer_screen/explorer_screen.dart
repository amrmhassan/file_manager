// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/dir_children_list_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerScreen extends StatefulWidget {
  final bool sizesExplorer;

  const ExplorerScreen({
    super.key,
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
              .getDirInfoByPath(
                  Provider.of<ExplorerProvider>(context, listen: false)
                      .currentActiveDir
                      .path);
      if (localFolderInfo != null && localFolderInfo.size != null) {
        parentSize = localFolderInfo.size;
      }
    });
  }

  @override
  void initState() {
    if (widget.sizesExplorer) updateParentSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateParentSize();
    return Column(
      children: [
        HomeItemHLine(),
        CurrentPathViewer(),
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
              //! remove this , it is only for testing UI
              sizesExplorer: widget.sizesExplorer,
              parentSize: parentSize,
            ),
          ),
      ],
    );
  }
}
