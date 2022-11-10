// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeItemHLine(),
        CurrentPathViewer(
          sizesExplorer: true,
        ),
        HomeItemHLine(),
        VSpace(factor: .5),
        // if (widget.sizesExplorer && parentSize == null)
        //   Expanded(
        //     child: Center(
        //       child: Text(
        //         'Loading',
        //         style: h4TextStyleInactive,
        //       ),
        //     ),
        //   )
        // else
        Expanded(
          child: ChildrenViewList(
            //! remove this , it is only for testing UI
            sizesExplorer: widget.sizesExplorer,
          ),
        ),
      ],
    );
  }
}
