// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/modals/details_modal/widgets/file_details.dart';
import 'package:explorer/global/modals/details_modal/widgets/folder_details.dart';
import 'package:explorer/global/modals/details_modal/widgets/multiple_items_details.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';

class SingleItemDetailsModal extends StatelessWidget {
  final List<StorageItemModel> selectedItems;

  const SingleItemDetailsModal({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  bool get singleItem {
    return selectedItems.length == 1;
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      color: kCardBackgroundColor,
      showTopLine: false,
      afterLinePaddingFactor: 1,
      bottomPaddingFactor: 0,
      child: singleItem
          ? selectedItems[0].entityType == EntityType.file
              ? FileDetails(storageItemModel: selectedItems[0])
              : FolderDetails(storageItemModel: selectedItems[0])
          : MultipleItemsDetails(selectedItems: selectedItems),
    );
  }
}
