// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/widgets/detail_item.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:path/path.dart' as path_operations;

class FileDetails extends StatelessWidget {
  final StorageItemModel storageItemModel;
  const FileDetails({
    super.key,
    required this.storageItemModel,
  });

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
              copyToClipboard(
                  context, path_operations.basename(storageItemModel.path));
            },
            child: Text(
              path_operations.basename(storageItemModel.path),
              style: h4TextStyle.copyWith(color: Colors.white),
            ),
          ),
          VSpace(),
          DetailItem(
            title: 'path'.i18n(),
            value: storageItemModel.path,
            allowCopy: true,
          ),
          DetailItem(
            title: 'size'.i18n(),
            value: handleConvertSize(storageItemModel.size ?? 0),
            valueColor: kInActiveTextColor,
          ),
          DetailItem(
            title: 'modified'.i18n(),
            value: DateFormat('yyyy-MM-dd   hh:mmaa')
                .format(storageItemModel.modified),
            valueColor: kInActiveTextColor,
          ),
          DetailItem(
            title: 'accessed'.i18n(),
            value: DateFormat('yyyy-MM-dd   hh:mmaa')
                .format(storageItemModel.accessed),
            valueColor: kInActiveTextColor,
          ),
        ],
      ),
    );
  }
}
