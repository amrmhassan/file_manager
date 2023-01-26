// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/explorer_screen/utils/sizes_utils.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_check_box.dart';
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
  final StorageItemModel? storageItemModel;
  final ShareSpaceItemModel? shareSpaceItemModel;
  final bool sizesExplorer;
  final int parentSize;
  final bool isSelected;
  final bool allowShowingFavIcon;
  final bool allowSelect;
  const ChildDirectoryItem({
    super.key,
    required this.fileName,
    this.storageItemModel,
    this.shareSpaceItemModel,
    required this.sizesExplorer,
    required this.parentSize,
    required this.isSelected,
    required this.allowShowingFavIcon,
    required this.allowSelect,
  });

  @override
  State<ChildDirectoryItem> createState() => _ChildDirectoryItemState();
}

class _ChildDirectoryItemState extends State<ChildDirectoryItem> {
  String get path {
    return widget.storageItemModel?.path ?? widget.shareSpaceItemModel!.path;
  }

  final GlobalKey key = GlobalKey();
  int? childrenNumber;
  FileStat? fileStat;
  double? height = 60;
  late int parentSize;
  bool isFavorite = false;
  String? error;

//? to add data to sqlite
  Future<void> addDataToSqlite(
    BuildContext context,
    List<String> directChildren,
    int itemCount,
  ) async {
    FolderItemInfoModel folderItemInfoModel = FolderItemInfoModel(
      path: path,
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

  //? this will check if the folder is favorite
  void updateIsFavorite() async {
    Future.delayed(Duration.zero).then((value) async {
      if (mounted) {
        bool isFav = await Provider.of<ListyProvider>(context, listen: false)
            .itemExistInAListy(
          path: path,
          listyTitle: defaultListyList.first.title,
        );
        if (mounted) {
          setState(() {
            isFavorite = isFav;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChildDirectoryItem oldWidget) {
    updateIsFavorite();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    updateIsFavorite();

    //? this will handle getting the parent size
    parentSize = allowSizesExpAnimation ? 0 : widget.parentSize;
    Future.delayed(entitySizePercentageDuration).then((value) {
      if (mounted) {
        setState(() {
          parentSize = widget.parentSize;
        });
      }
    });
    //? this is for setting the height to animate
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
                .getFolderInfo(path);
        if (folderItemInfoModel != null) {
          if (mounted) {
            setState(() {
              childrenNumber = folderItemInfoModel.itemCount;
            });
          }
        }
        FileStat? fState = Directory(path).statSync();
        if (mounted) {
          setState(() {
            fileStat = fState;
          });
        }
        bool doUpdateInfo = updateFolderInfo(
            fState.modified, folderItemInfoModel?.dateCaptured);
        if (!doUpdateInfo) return;
        int cn = await compute(getFolderChildrenNumber, path);
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
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    Directory dir = Directory(path);
    bool exists = dir.existsSync();

    return !exists && widget.storageItemModel != null
        ? SizedBox()
        : Stack(
            children: [
              if (widget.sizesExplorer)
                AnimatedContainer(
                  duration: entitySizePercentageDuration,
                  width: Responsive.getWidthPercentage(
                    context,
                    getSizePercentage(
                      widget.storageItemModel!.size ?? 0,
                      parentSize,
                    ),
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
                        Stack(
                          alignment: Alignment.topRight,
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              'assets/icons/folder_colorful.png',
                              width: largeIconSize,
                            ),
                            if (isFavorite && widget.allowShowingFavIcon)
                              Positioned(
                                right: -smallIconSize / 2,
                                top: -smallIconSize / 5,
                                child: Image.asset(
                                  'assets/icons/heart.png',
                                  width: smallIconSize,
                                ),
                              ),
                          ],
                        ),
                        HSpace(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.fileName,
                                style: h4LightTextStyle,
                                maxLines: 1,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              widget.storageItemModel == null
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        error == null
                                            ? Text(
                                                childrenNumber == null
                                                    ? '...'
                                                    : '$childrenNumber Items',
                                                style: h5InactiveTextStyle
                                                    .copyWith(
                                                  height: 1,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(
                                                'System',
                                                style: h5InactiveTextStyle
                                                    .copyWith(height: 1),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                        if (fileStat != null)
                                          Row(
                                            children: [
                                              Text(
                                                ' | ',
                                                style: h5InactiveTextStyle
                                                    .copyWith(height: 1),
                                              ),
                                              Text(
                                                widget.sizesExplorer
                                                    ? handleConvertSize(widget
                                                            .storageItemModel!
                                                            .size ??
                                                        0)
                                                    : DateFormat('yyyy-MM-dd')
                                                        .format(
                                                            fileStat!.changed),
                                                style: h5InactiveTextStyle
                                                    .copyWith(height: 1),
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
                            sizePercentageString(
                              getSizePercentage(
                                widget.storageItemModel!.size ?? 0,
                                parentSize,
                              ),
                            ),
                            style: h4TextStyleInactive.copyWith(
                              color: kInActiveTextColor.withOpacity(.7),
                            ),
                          ),
                        foProvider.exploreMode == ExploreMode.selection &&
                                widget.allowSelect
                            ? EntityCheckBox(
                                isSelected: widget.isSelected,
                                storageItemModel: widget.storageItemModel!,
                              )
                            : Image.asset(
                                'assets/icons/right-arrow.png',
                                width: mediumIconSize,
                                color: kMainIconColor.withOpacity(.4),
                              )
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
