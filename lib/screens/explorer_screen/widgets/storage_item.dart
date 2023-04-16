// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/animation_wrapper.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_item_directory.dart';
import 'package:explorer/utils/files_operations_utils/files_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animator/flutter_animator.dart';
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
  final Function(String path)? onFileTapped;
  final bool network;
  final String? viewedFilePath;
  final Function(String path, EntityType entityType, bool network)?
      onLongPressed;
  final bool? isSelected;
  final ExploreMode? exploreMode;
  final VoidCallback? onSelectClicked;

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
    this.onFileTapped,
    this.network = false,
    this.viewedFilePath,
    this.onLongPressed,
    this.isSelected,
    this.exploreMode,
    this.onSelectClicked,
  });

  @override
  State<StorageItem> createState() => _StorageItemState();
}

class _StorageItemState extends State<StorageItem> {
  GlobalKey globalKey = GlobalKey();
  bool hint = false;
  double? height;

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

  void handleViewedFileHint() {
    if (widget.viewedFilePath == null) return;
    if (widget.viewedFilePath == null ||
        widget.viewedFilePath != widget.storageItemModel?.path) return;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {
          height = globalKey.currentContext?.size?.height;
        });
      }
    });
    hint = true;
  }

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
    handleViewedFileHint();

    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    var expProviderFalse = expPF(context);

    return Stack(
      children: [
        if (hint)
          FadeOut(
            preferences: AnimationPreferences(duration: Duration(seconds: 5)),
            child: Container(
              width: double.infinity,
              height: height,
              color: Colors.white.withOpacity(.2),
            ),
          ),
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
            key: globalKey,
            onTap: widget.allowClick
                ? () async {
                    //? update the clicked item first
                    expPF(context).increaseClickedItem(path);
                    if (entityType == EntityType.folder) {
                      //* here open the folder
                      widget.onDirTapped(path);
                    } else {
                      if (widget.onFileTapped == null) {
                        openFile(path, context);
                      } else {
                        widget.onFileTapped!(path);
                      }
                    }
                  }
                : null,
            onLongPress: widget.onLongPressed != null
                ? () => widget.onLongPressed!(
                      widget.storageItemModel?.path ??
                          widget.shareSpaceItemModel!.path,
                      widget.storageItemModel?.entityType ??
                          widget.shareSpaceItemModel!.entityType,
                      widget.storageItemModel == null,
                    )
                : widget.allowSelect &&
                        expProviderFalse.currentActiveDir.path !=
                            initialDirs.first.path
                    ? () {
                        var expProvider = Provider.of<ExplorerProvider>(context,
                            listen: false);

                        foProviderFalse.toggleFromSelectedItems(
                            widget.storageItemModel!, expProvider);
                      }
                    : null,
            borderRadius: 0,
            child: Stack(
              children: [
                entityType == EntityType.folder
                    ? ChildDirectoryItem(
                        fileName: path_operations.basename(path),
                        storageItemModel: widget.storageItemModel,
                        parentSize: widget.parentSize,
                        sizesExplorer: widget.sizesExplorer,
                        isSelected: widget.isSelected ?? isSelected(context),
                        allowShowingFavIcon: widget.allowShowingFavIcon,
                        allowSelect: widget.allowSelect,
                        shareSpaceItemModel: widget.shareSpaceItemModel,
                        exploreMode: widget.exploreMode,
                        onSelectClicked: widget.onSelectClicked,
                      )
                    : ChildFileItem(
                        storageItemModel: widget.storageItemModel,
                        parentSize: widget.parentSize,
                        sizesExplorer: widget.sizesExplorer,
                        isSelected: widget.isSelected ?? isSelected(context),
                        allowSelect: widget.allowSelect,
                        shareSpaceItemModel: widget.shareSpaceItemModel,
                        network: widget.network,
                        exploreMode: widget.exploreMode,
                        onSelectClicked: widget.onSelectClicked,
                      ),
                if (kDebugMode)
                  Text((widget.storageItemModel?.arrangeFactor).toString())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
