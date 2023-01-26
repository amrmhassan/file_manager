// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/utils/sizes_utils.dart';
import 'package:explorer/screens/explorer_screen/widgets/media_player_button.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_check_box.dart';
import 'package:explorer/screens/explorer_screen/widgets/file_size_with_date_modified.dart';
import 'package:explorer/screens/explorer_screen/widgets/file_thumbnail.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart' as path_operations;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChildFileItem extends StatefulWidget {
  final StorageItemModel? storageItemModel;
  final ShareSpaceItemModel? shareSpaceItemModel;
  final bool sizesExplorer;
  final int parentSize;
  final bool isSelected;
  final bool allowSelect;

  const ChildFileItem({
    super.key,
    this.storageItemModel,
    this.shareSpaceItemModel,
    required this.sizesExplorer,
    required this.parentSize,
    required this.isSelected,
    required this.allowSelect,
  });

  @override
  State<ChildFileItem> createState() => _ChildFileItemState();
}

class _ChildFileItemState extends State<ChildFileItem> {
  String get path =>
      widget.storageItemModel?.path ?? widget.shareSpaceItemModel!.path;
  final GlobalKey key = GlobalKey();

  Directory? tempDir;
  double? height = 100;
  late int parentSize;
  @override
  void initState() {
    parentSize = allowSizesExpAnimation ? 0 : widget.parentSize;
    Future.delayed(entitySizePercentageDuration).then((value) {
      if (mounted) {
        setState(() {
          parentSize = widget.parentSize < 0 ? 0 : widget.parentSize;
        });
      }
    });
    Future.delayed(Duration.zero).then((value) async {
      tempDir = await getTemporaryDirectory();
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.sizesExplorer) {
        setState(() {
          height = key.currentContext?.size?.height;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    // this code took 200 micro second which is very small amount of time
    File file = File(path);
    bool exists = file.existsSync();

    return !exists && widget.storageItemModel != null
        ? SizedBox()
        : Stack(
            children: [
              if (widget.sizesExplorer)
                AnimatedContainer(
                  curve: true ? Curves.elasticOut : Curves.easeInSine,
                  duration: entitySizePercentageDuration,
                  width: Responsive.getWidthPercentage(
                    context,
                    getSizePercentage(
                        widget.storageItemModel!.size ?? 0, parentSize),
                  ),
                  color: kInactiveColor.withOpacity(.2),
                  height: height,
                ),
              Column(
                key: key,
                children: [
                  VSpace(factor: .5),
                  PaddingWrapper(
                    child: Row(
                      children: [
                        FileThumbnail(
                          path: path,
                          sharingFile: widget.storageItemModel == null,
                        ),
                        HSpace(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.sizesExplorer ||
                                        foProvider.exploreMode ==
                                            ExploreMode.selection
                                    ? path_operations.basename(path)
                                    : getFileName(path),
                                style: h4LightTextStyle,
                                //! fix the file name
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              if (widget.storageItemModel != null)
                                widget.sizesExplorer
                                    ? FileSizeWithDateModified(
                                        fileSize: handleConvertSize(
                                          widget.storageItemModel!.size ?? 0,
                                        ),
                                        hasData: true,
                                        modified:
                                            widget.storageItemModel!.modified,
                                      )
                                    : FutureBuilder<FileStat>(
                                        future: File(path).stat(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            String fileSize = handleConvertSize(
                                                snapshot.data?.size ?? 0);
                                            return FileSizeWithDateModified(
                                              fileSize: fileSize,
                                              hasData: snapshot.data != null,
                                              modified: snapshot.data!.modified,
                                            );
                                          } else {
                                            return Text(
                                              '...',
                                              style:
                                                  h4TextStyleInactive.copyWith(
                                                color: kInactiveColor,
                                                height: 1,
                                              ),
                                            );
                                          }
                                        }),
                            ],
                          ),
                        ),
                        HSpace(),
                        MediaPlayerButton(
                          mediaPath: path,
                        ),
                        HSpace(),
                        foProvider.exploreMode == ExploreMode.selection &&
                                widget.allowSelect
                            ? EntityCheckBox(
                                isSelected: widget.isSelected,
                                storageItemModel: widget.storageItemModel!,
                              )
                            : Container(
                                constraints:
                                    BoxConstraints(maxWidth: largeIconSize),
                                child: Text(
                                  widget.sizesExplorer
                                      ? sizePercentageString(
                                          getSizePercentage(
                                            widget.storageItemModel!.size ?? 0,
                                            parentSize,
                                          ),
                                        )
                                      : getFileExtension(path),
                                  style: h4TextStyleInactive.copyWith(
                                    color: kInActiveTextColor.withOpacity(.7),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ],
                    ),
                  ),
                  VSpace(factor: .5),
                  HomeItemHLine(),
                ],
              ),
            ],
          );
  }
}
