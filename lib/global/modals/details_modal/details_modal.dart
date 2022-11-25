// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/details_modal/widgets/file_details.dart';
import 'package:explorer/global/modals/details_modal/widgets/folder_details.dart';
import 'package:explorer/global/modals/details_modal/widgets/multiple_items_details.dart';
import 'package:explorer/global/modals/widgets/detail_item.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_operations;
import 'package:provider/provider.dart';

class SingleItemDetailsModal extends StatefulWidget {
  final List<StorageItemModel> selectedItems;

  const SingleItemDetailsModal({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<SingleItemDetailsModal> createState() => _SingleItemDetailsModalState();
}

class _SingleItemDetailsModalState extends State<SingleItemDetailsModal> {
  int? size;
  int? files;
  int? folders;

  //? to get multiple selected items info
  void getMultipleItemsInfo() async {
    int s = 0;
    int fi = 0;
    int fo = 0;

    Provider.of<FilesOperationsProvider>(context, listen: false)
        .clearAllSelectedItems(
            Provider.of<ExplorerProvider>(context, listen: false));
    for (var item in widget.selectedItems) {
      if (item.entityType == EntityType.file) {
        fi++;
        s += item.size ?? 0;
      } else {
        // FolderItemInfoModel? folderItemInfoModel =
        //     await getFolderInfo(item.path);
        FolderItemInfoModel? folderItemInfoModel;
        if (folderItemInfoModel != null) {
          fo++;
          s += folderItemInfoModel.size!;
          fi += folderItemInfoModel.itemCount!;
        }
      }
    }
    setState(() {
      size = s;
      files = fi;
      folders = fo;
    });
  }

//? to get single item info
  void getSingleItemInfo() async {
    Provider.of<FilesOperationsProvider>(context, listen: false)
        .clearAllSelectedItems(
            Provider.of<ExplorerProvider>(context, listen: false));
    if (widget.selectedItems[0].entityType == EntityType.file) {
      setState(() {
        size = widget.selectedItems[0].size;
      });
    } else {
      // FolderItemInfoModel? folderItemInfoModel =
      //     await getFolderInfo(widget.selectedItems[0].path);
      FolderItemInfoModel? folderItemInfoModel;
      if (folderItemInfoModel != null) {
        setState(() {
          files = folderItemInfoModel.itemCount;
          size = folderItemInfoModel.size;
        });
      }
    }
  }

  // //? to get a folder info
  // Future<FolderItemInfoModel?> getFolderInfo(String path) async {
  //   //! an error will happen here because if the folder isn't in the sqlite it won't show or update its info
  //   LocalFolderInfo? localFolderInfo =
  //       await getFolderSizeFromDb(widget.selectedItems[0].path);
  //   if (localFolderInfo == null) return null;
  //   setState(() {
  //     size = localFolderInfo.size;
  //   });
  //   if (widget.selectedItems[0].modified
  //       .isAfter(localFolderInfo.dateCaptured)) {
  //     // this will holder the whole folder files, size from sub children
  //     FolderItemInfoModel calcedFolderInfo =
  //         await compute(calcFolderDetails, widget.selectedItems[0].path);

  //     updateFolderSizeInSqlite(widget.selectedItems[0], calcedFolderInfo.size!);
  //     return calcedFolderInfo;
  //   }
  //   return null;
  // }

  //? to hanle details type (single, multiple)
  void handleEntitySize() {
    Future.delayed(Duration.zero).then((value) async {
      if (singleItem) {
        getSingleItemInfo();
      } else {
        getMultipleItemsInfo();
      }
    });
  }

  bool get singleItem {
    return widget.selectedItems.length == 1;
  }

  @override
  void initState() {
    handleEntitySize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      color: kCardBackgroundColor,
      showTopLine: false,
      afterLinePaddingFactor: 1,
      child: singleItem
          ? widget.selectedItems[0].entityType == EntityType.file
              ? FileDetails(storageItemModel: widget.selectedItems[0])
              : FolderDetails(storageItemModel: widget.selectedItems[0])
          : MultipleItemsDetails(selectedItems: widget.selectedItems),
    );
  }
}
