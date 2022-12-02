// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/widgets/detail_item.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/folder_details_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/files_operations_utils/folder_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_operations;

class FolderDetails extends StatefulWidget {
  final StorageItemModel storageItemModel;

  const FolderDetails({
    super.key,
    required this.storageItemModel,
  });

  @override
  State<FolderDetails> createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {
  late FolderDetailsModel folderDetailsModel;

  //? to get single item info
  void getFolderInfo() async {
    folderDetailsModel = FolderDetailsModel(path: widget.storageItemModel.path);

    getFolderDetails(
      storageItemModel: widget.storageItemModel,
      callAfterAvailable: (fdm, oldSize) {
        if (mounted) {
          setState(() {
            folderDetailsModel = FolderDetailsModel(
              path: folderDetailsModel.path,
              size: fdm.size ?? folderDetailsModel.size,
              filesCount: fdm.filesCount ?? folderDetailsModel.filesCount,
              folderCount: fdm.folderCount ?? folderDetailsModel.folderCount,
            );
          });
        }
      },
    );
  }

  @override
  void initState() {
    getFolderInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      color: kCardBackgroundColor,
      showTopLine: false,
      afterLinePaddingFactor: 1,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              copyPathToClipboard(context,
                  path_operations.basename(widget.storageItemModel.path));
            },
            child: Text(
              path_operations.basename(widget.storageItemModel.path),
              style: h4TextStyle.copyWith(color: Colors.white),
            ),
          ),
          VSpace(),
          DetailItem(
            title: 'Path: ',
            value: widget.storageItemModel.path,
            allowCopy: true,
          ),
          DetailItem(
            title: 'Size: ',
            value: handleConvertSize(folderDetailsModel.size ?? 0),
            valueColor: kInActiveTextColor,
          ),
          DetailItem(
            title: 'Files: ',
            value: (folderDetailsModel.filesCount ?? 0).toString(),
            valueColor: kInActiveTextColor,
          ),
          DetailItem(
            title: 'Folders: ',
            value: (folderDetailsModel.folderCount ?? 0).toString(),
            valueColor: kInActiveTextColor,
          ),
          DetailItem(
            title: 'Modified: ',
            value: DateFormat('yyyy-MM-dd   hh:mmaa')
                .format(widget.storageItemModel.modified),
            valueColor: kInActiveTextColor,
          ),
        ],
      ),
    );
  }
}
