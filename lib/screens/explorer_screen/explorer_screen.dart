// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:flutter/material.dart';

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
