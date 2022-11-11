// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_item_directory.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool isSelected(BuildContext context) {
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return foProvider.isSelected(storageItemModel.path);
  }

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return Stack(
      children: [
        //? i added this null widget just to update this UI when the selected items changes(don't remove it)
        SizedBox(
          width: 0,
          height: 0,
          child: Text(
            foProvider.selectedItems.length.toString(),
            style: h4TextStyleInactive,
          ),
        ),
        ButtonWrapper(
          onTap: () async {
            if (isDir(storageItemModel.path)) {
              //* here open the folder
              onDirTapped(storageItemModel.path);
            } else {
              //* here perform open the file
              await OpenFile.open(storageItemModel.path);
            }
          },
          //* this will delay the normal tap response
          // onDoubleTapped: () {
          //   if (isDir(storageItemModel.path)) {
          //     //? view the folder details screen here
          //   } else {
          //     //? fast open file (audio, video, text)
          //   }
          // },
          onLongPress: () {
            foProviderFalse.toggleFromSelectedItems(storageItemModel);
          },
          borderRadius: 0,
          child: isDir(storageItemModel.path)
              ? ChildDirectoryItem(
                  fileName: path.basename(storageItemModel.path),
                  storageItemModel: storageItemModel,
                  parentSize: parentSize,
                  sizesExplorer: sizesExplorer,
                  isSelected: isSelected(context),
                )
              : ChildFileItem(
                  storageItemModel: storageItemModel,
                  parentSize: parentSize,
                  sizesExplorer: sizesExplorer,
                  isSelected: isSelected(context),
                ),
        ),
      ],
    );
  }
}
