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
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class ChildFileItem extends StatefulWidget {
  final StorageItemModel fileSystemEntityInfo;
  final bool sizesExplorer;
  final int parentSize;

  const ChildFileItem({
    super.key,
    required this.fileSystemEntityInfo,
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
      setState(() {
        height = key.currentContext?.size?.height;
      });
    });
    super.initState();
  }

  double getSizePercentage() {
    return ((widget.fileSystemEntityInfo.size ?? 0) / widget.parentSize) * 1;
  }

//? update this to be readable
  String sizePercentagleString() {
    return '${(getSizePercentage() * 100).toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.sizesExplorer)
          Container(
            width: Responsive.getWidthPercentage(
              context,
              getSizePercentage(),
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
                        path.extension(widget.fileSystemEntityInfo.path)),
                    width: largeIconSize,
                  ),
                  HSpace(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.sizesExplorer
                              ? path.basename(widget.fileSystemEntityInfo.path)
                              : getFileName(widget.fileSystemEntityInfo.path),
                          style: h4LightTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        FutureBuilder<FileStat>(
                            future:
                                File(widget.fileSystemEntityInfo.path).stat(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                String fileSize =
                                    handleConvertSize(snapshot.data?.size ?? 0);
                                return Row(
                                  children: [
                                    Text(
                                      fileSize,
                                      style: h4TextStyleInactive.copyWith(
                                        color: kInactiveColor,
                                        height: 1,
                                      ),
                                    ),
                                    if (snapshot.data != null)
                                      Row(
                                        children: [
                                          Text(
                                            ' | ',
                                            style: h4TextStyleInactive.copyWith(
                                              color: kInactiveColor,
                                              height: 1,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                snapshot.data!.modified),
                                            style: h4TextStyleInactive.copyWith(
                                              color: kInactiveColor,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
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
                        ? sizePercentagleString()
                        : getFileExtension(widget.fileSystemEntityInfo.path),
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
