// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/screens/explorer_screen/utils/sizes_utils.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

int getFolderChildrenNumber(String path) {
  Directory directory = Directory(path);
  return directory.listSync().length;
}

class ChildDirectoryItem extends StatefulWidget {
  final String fileName;
  final StorageItemModel storageItemModel;
  final bool sizesExplorer;
  final int parentSize;

  const ChildDirectoryItem({
    super.key,
    required this.fileName,
    required this.storageItemModel,
    required this.sizesExplorer,
    required this.parentSize,
  });

  @override
  State<ChildDirectoryItem> createState() => _ChildDirectoryItemState();
}

class _ChildDirectoryItemState extends State<ChildDirectoryItem> {
  final GlobalKey key = GlobalKey();
  int? childrenNumber;
  FileStat? fileStat;
  double? height = 60;
  late int parentSize;
  double marginAnimations = allowNormalExpAnimation ? 20 : 0;

  String? error;

//? to add data to sqlite
  Future<void> addDataToSqlite(
    BuildContext context,
    List<String> directChildren,
    int itemCount,
  ) async {
    FolderItemInfoModel folderItemInfoModel = FolderItemInfoModel(
      path: widget.storageItemModel.path,
      name: widget.fileName,
      itemCount: itemCount,
      dateCaptured: DateTime.now(),
    );

    return Provider.of<ChildrenItemsProvider>(context, listen: false)
        .addFolderInfo(folderItemInfoModel);
  }

//? to cancel updating folder info if the date that we captured it's info is after it's modification date
  bool updateFolderInfo(DateTime? modified, DateTime? dateCaptured) {
    if (modified == null || dateCaptured == null) return true;
    bool update = dateCaptured.isBefore(modified);
    return update;
  }

  // void updateFolderSize() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     //? here i will update the current active dir size
  //     LocalFolderInfo? localFolderInfo =
  //         await Provider.of<AnalyzerProvider>(context, listen: false)
  //             .getDirInfoByPath(widget.storageItemModel.path);
  //     if (localFolderInfo != null && localFolderInfo.size != null) {
  //       setState(() {
  //         size = localFolderInfo.size;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    parentSize = allowSizesExpAnimation ? 0 : widget.parentSize;
    Future.delayed(entitySizePercentageDuration).then((value) {
      if (mounted) {
        setState(() {
          parentSize = widget.parentSize;
          marginAnimations = 0;
        });
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          height = key.currentContext?.size?.height ?? 0;
        });
      }
    });
    Future.delayed(Duration.zero).then((value) async {
      try {
        FolderItemInfoModel? folderItemInfoModel =
            Provider.of<ChildrenItemsProvider>(context, listen: false)
                .getFolderInfo(widget.storageItemModel.path);
        if (folderItemInfoModel != null) {
          if (mounted) {
            setState(() {
              childrenNumber = folderItemInfoModel.itemCount;
            });
          }
        }
        FileStat? fState = Directory(widget.storageItemModel.path).statSync();
        if (mounted) {
          setState(() {
            fileStat = fState;
          });
        }
        bool doUpdateInfo = updateFolderInfo(
            fState.modified, folderItemInfoModel?.dateCaptured);
        if (!doUpdateInfo) return;
        int cn = await compute(
            getFolderChildrenNumber, widget.storageItemModel.path);
        await addDataToSqlite(context, [], cn);
        if (!mounted) {
          return;
        }
        if (mounted) {
          setState(() {
            childrenNumber = cn;
          });
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          error = e.toString();
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
          AnimatedContainer(
            duration: entitySizePercentageDuration,
            width: Responsive.getWidthPercentage(
              context,
              getSizePercentage(
                widget.storageItemModel.size ?? 0,
                parentSize,
              ),
            ),
            color: kInactiveColor.withOpacity(.2),
            height: height,
          ),
        AnimatedContainer(
          duration: entitySizePercentageDuration,
          margin: EdgeInsets.only(bottom: marginAnimations),
          child: Column(
            key: key,
            children: [
              VSpace(factor: .5),
              PaddingWrapper(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/icons/folder_colorful.png',
                      width: largeIconSize,
                    ),
                    HSpace(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.fileName,
                            style: h4LightTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              error == null
                                  ? Text(
                                      childrenNumber == null
                                          ? '...'
                                          : '$childrenNumber Items',
                                      style: h5InactiveTextStyle.copyWith(
                                          height: 1),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : Text(
                                      'System',
                                      style: h5InactiveTextStyle.copyWith(
                                          height: 1),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              if (fileStat != null)
                                Row(
                                  children: [
                                    Text(
                                      ' | ',
                                      style: h5InactiveTextStyle.copyWith(
                                          height: 1),
                                    ),
                                    Text(
                                      widget.sizesExplorer
                                          ? handleConvertSize(
                                              widget.storageItemModel.size ?? 0)
                                          : DateFormat('yyyy-MM-dd')
                                              .format(fileStat!.changed),
                                      style: h5InactiveTextStyle.copyWith(
                                          height: 1),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.sizesExplorer)
                      Text(
                        sizePercentagleString(
                          getSizePercentage(
                            widget.storageItemModel.size ?? 0,
                            parentSize,
                          ),
                        ),
                        style: h4TextStyleInactive.copyWith(
                          color: kInActiveTextColor.withOpacity(.7),
                        ),
                      ),
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      width: mediumIconSize,
                      color: kInactiveColor,
                    )
                  ],
                ),
              ),
              VSpace(factor: .5),
              HomeItemHLine(),
            ],
          ),
        ),
      ],
    );
  }
}
