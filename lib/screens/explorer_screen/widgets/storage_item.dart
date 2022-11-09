// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_item_directory.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class StorageItem extends StatelessWidget {
  final StorageItemModel storageItemModel;
  final Function(String path) onDirTapped;
  final bool sizesExplorer;
  final int parentSize;

  const StorageItem({
    super.key,
    required this.storageItemModel,
    required this.onDirTapped,
    required this.sizesExplorer,
    required this.parentSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ButtonWrapper(
          onTap: () {
            if (isDir(storageItemModel.path)) {
              onDirTapped(storageItemModel.path);
            }
          },
          borderRadius: 0,
          child: isDir(storageItemModel.path)
              ? ChildDirectoryItem(
                  fileName: path.basename(storageItemModel.path),
                  storageItemModel: storageItemModel,
                  parentSize: parentSize,
                  sizesExplorer: sizesExplorer,
                )
              : ChildFileItem(
                  storageItemModel: storageItemModel,
                  parentSize: parentSize,
                  sizesExplorer: sizesExplorer,
                ),
        ),
      ],
    );
  }
}
