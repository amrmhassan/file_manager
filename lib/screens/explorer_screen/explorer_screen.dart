// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/explorer_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:flutter/material.dart';

class ExplorerScreen extends StatelessWidget {
  final Function(String path) clickFolder;
  final List<FileSystemEntity> viewedChildren;
  final Directory activeDirectory;
  final String? error;
  final bool loading;
  final Directory currentActiveDir;
  final VoidCallback goHome;
  final Function(String path) updateActivePath;
  final List<FileSystemEntity> childrenToPassToList;

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
    required this.childrenToPassToList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomeItemHLine(),
        CurrentPathViewer(
          currentActiveDir: currentActiveDir,
          goHome: goHome,
          clickFolder: updateActivePath,
        ),
        HomeItemHLine(),
        VSpace(factor: .5),
        Expanded(
          child: ChildrenViewList(
            clickFolder: updateActivePath,
            viewedChildren: childrenToPassToList,
            error: error,
            loading: loading,
            activeDirectory: currentActiveDir,
          ),
        ),
      ],
    );
  }
}
