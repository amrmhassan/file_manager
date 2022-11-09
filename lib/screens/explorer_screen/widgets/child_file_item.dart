// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/screens/explorer_screen/utils/sizes_utils.dart';
import 'package:explorer/screens/explorer_screen/widgets/file_size_with_date_modified.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart' as path;

class ChildFileItem extends StatefulWidget {
  final StorageItemModel storageItemModel;
  final bool sizesExplorer;
  final int parentSize;

  const ChildFileItem({
    super.key,
    required this.storageItemModel,
    required this.sizesExplorer,
    required this.parentSize,
  });

  @override
  State<ChildFileItem> createState() => _ChildFileItemState();
}

class _ChildFileItemState extends State<ChildFileItem> {
  final GlobalKey key = GlobalKey();
  double? height;
  @override
  void initState() {
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
    return Stack(
      children: [
        if (widget.sizesExplorer)
          Container(
            width: Responsive.getWidthPercentage(
              context,
              getSizePercentage(
                  widget.storageItemModel.size ?? 0, widget.parentSize),
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
                  Image.asset(
                    getFileTypeIcon(
                        path.extension(widget.storageItemModel.path)),
                    width: largeIconSize,
                  ),
                  HSpace(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sizesExplorer
                              ? path.basename(widget.storageItemModel.path)
                              : getFileName(widget.storageItemModel.path),
                          style: h4LightTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        widget.sizesExplorer
                            ? FileSizeWithDateModifed(
                                fileSize: handleConvertSize(
                                  widget.storageItemModel.size ?? 0,
                                ),
                                hasData: true,
                                modified: widget.storageItemModel.modified,
                              )
                            : FutureBuilder<FileStat>(
                                future:
                                    File(widget.storageItemModel.path).stat(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    String fileSize = handleConvertSize(
                                        snapshot.data?.size ?? 0);
                                    return FileSizeWithDateModifed(
                                      fileSize: fileSize,
                                      hasData: snapshot.data != null,
                                      modified: snapshot.data!.modified,
                                    );
                                  } else {
                                    return Text(
                                      '...',
                                      style: h4TextStyleInactive.copyWith(
                                        color: kInactiveColor,
                                        height: 1,
                                      ),
                                    );
                                  }
                                }),
                      ],
                    ),
                  ),
                  Text(
                    widget.sizesExplorer
                        ? sizePercentagleString(getSizePercentage(
                            widget.storageItemModel.size ?? 0,
                            widget.parentSize,
                          ))
                        : getFileExtension(widget.storageItemModel.path),
                    style: h4TextStyleInactive.copyWith(
                      color: kInActiveTextColor.withOpacity(.7),
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
