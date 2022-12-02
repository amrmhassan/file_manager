// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/widgets/detail_item.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/files_operations_utils/folder_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MultipleItemsDetails extends StatefulWidget {
  final List<StorageItemModel> selectedItems;
  const MultipleItemsDetails({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<MultipleItemsDetails> createState() => _MultipleItemsDetailsState();
}

class _MultipleItemsDetailsState extends State<MultipleItemsDetails> {
  int size = 0;
  int filesCount = 0;
  int foldersCount = 0;

//? to get multiple items info
  void getMultipleItemsDetails() {
    for (var item in widget.selectedItems) {
      if (item.entityType == EntityType.file) {
        setState(() {
          size += item.size ?? 0;
          filesCount++;
        });
      } else {
        foldersCount++;
        getFolderDetails(
            storageItemModel: item,
            callAfterAvailable: (fdm, oldSize) {
              if (mounted) {
                setState(() {
                  size = size + (fdm.size ?? 0) - (oldSize ?? 0);
                  foldersCount += fdm.folderCount ?? 0;
                  filesCount += fdm.filesCount ?? 0;
                });
              }
            });
      }
    }
  }

  @override
  void initState() {
    getMultipleItemsDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${widget.selectedItems.length} Items',
          style: h4TextStyle.copyWith(color: Colors.white),
        ),
        VSpace(),
        DetailItem(
          title: 'Files: ',
          value: filesCount.toString(),
          valueColor: kInActiveTextColor,
        ),
        DetailItem(
          title: 'Folders: ',
          value: NumberFormat('#,###.##').format(foldersCount),
          valueColor: kInActiveTextColor,
        ),
        DetailItem(
          title: 'Size: ',
          value: handleConvertSize(size),
          valueColor: kInActiveTextColor,
        ),
      ],
    );
  }
}
