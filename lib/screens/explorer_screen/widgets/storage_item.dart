// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/animation_wrapper.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_item_directory.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path/path.dart' as path_operations;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorageItem extends StatefulWidget {
  final StorageItemModel? storageItemModel;
  final Function(String path) onDirTapped;
  final bool sizesExplorer;
  final int parentSize;
  final bool allowSelect;
  final bool allowShowingFavIcon;
  final bool allowClick;
  final ShareSpaceItemModel? shareSpaceItemModel;

  const StorageItem({
    super.key,
    this.storageItemModel,
    required this.onDirTapped,
    required this.sizesExplorer,
    required this.parentSize,
    this.allowClick = true,
    this.allowSelect = true,
    this.allowShowingFavIcon = false,
    this.shareSpaceItemModel,
  });

  @override
  State<StorageItem> createState() => _StorageItemState();
}

class _StorageItemState extends State<StorageItem> {
  bool isSelected(BuildContext context) {
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return foProvider.isSelected(path);
  }

  String get path =>
      widget.storageItemModel?.path ?? widget.shareSpaceItemModel!.path;
  EntityType get entityType =>
      widget.storageItemModel?.entityType ??
      widget.shareSpaceItemModel!.entityType;

  @override
  void initState() {
    if (widget.storageItemModel == null && widget.shareSpaceItemModel == null) {
      throw Exception(
          'You must provide storageItemModel or shareSpaceItemModel');
    }
    super.initState();
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
        AnimationWrapper(
          child: ButtonWrapper(
            onTap: widget.allowClick
                ? () async {
                    if (entityType == EntityType.folder) {
                      //* here open the folder
                      widget.onDirTapped(path);
                    } else {
                      //* here perform open the file
                      await open_file.OpenFile.open(path);
                      await foProviderFalse.addToRecentlyOpened(path);
                    }
                  }
                : null,
            onLongPress: widget.allowSelect
                ? () {
                    var expProvider =
                        Provider.of<ExplorerProvider>(context, listen: false);

                    foProviderFalse.toggleFromSelectedItems(
                        widget.storageItemModel!, expProvider);
                  }
                : null,
            borderRadius: 0,
            child: entityType == EntityType.folder
                ? ChildDirectoryItem(
                    fileName: path_operations.basename(path),
                    storageItemModel: widget.storageItemModel,
                    parentSize: widget.parentSize,
                    sizesExplorer: widget.sizesExplorer,
                    isSelected: isSelected(context),
                    allowShowingFavIcon: widget.allowShowingFavIcon,
                    allowSelect: widget.allowSelect,
                    shareSpaceItemModel: widget.shareSpaceItemModel,
                  )
                : ChildFileItem(
                    storageItemModel: widget.storageItemModel,
                    parentSize: widget.parentSize,
                    sizesExplorer: widget.sizesExplorer,
                    isSelected: isSelected(context),
                    allowSelect: widget.allowSelect,
                    shareSpaceItemModel: widget.shareSpaceItemModel,
                  ),
          ),
        ),
      ],
    );
  }
}
