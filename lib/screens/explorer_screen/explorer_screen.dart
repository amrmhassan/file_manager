// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/explorer_tabs/explorer_tabs.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerScreen extends StatefulWidget {
  final bool sizesExplorer;
  final bool viewFile;

  const ExplorerScreen({
    super.key,
    this.sizesExplorer = false,
    required this.viewFile,
  });

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    var expProvider = expP(context);
    return Column(
      children: [
        HomeItemHLine(),
        CurrentPathViewer(
          sizesExplorer: true,
        ),
        HomeItemHLine(),
        VSpace(factor: .5),
        Expanded(
          child: ChildrenViewList(
            sizesExplorer: widget.sizesExplorer,
            viewFile: widget.viewFile,
          ),
        ),
        ExplorerTabs(),
        if (!foProvider.loadingOperation) EntityOperations(),
      ],
    );
  }
}
