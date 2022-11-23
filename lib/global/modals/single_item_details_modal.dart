// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/widgets/detail_item.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/isolates/folder_info_isolates.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_operations;

class SingleItemDetailsModal extends StatefulWidget {
  final StorageItemModel singleItem;

  const SingleItemDetailsModal({
    Key? key,
    required this.singleItem,
  }) : super(key: key);

  @override
  State<SingleItemDetailsModal> createState() => _SingleItemDetailsModalState();
}

class _SingleItemDetailsModalState extends State<SingleItemDetailsModal> {
  int? size;

  void handleEntitySize() {
    Future.delayed(Duration.zero).then((value) async {
      if (widget.singleItem.entityType == EntityType.file) {
        setState(() {
          size = widget.singleItem.size;
        });
      } else {
        LocalFolderInfo? localFolderInfo =
            await getFolderSize(widget.singleItem.path);
        if (localFolderInfo == null) return;
        setState(() {
          size = localFolderInfo.size;
        });
        if (widget.singleItem.modified.isAfter(localFolderInfo.dateCaptured)) {
          int calcedSize =
              await compute(calcFolderSize, widget.singleItem.path);
          setState(() {
            size = calcedSize;
          });
          updateFolderSizeInSqlite(widget.singleItem, calcedSize);
        }
      }
    });
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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              copyPathToClipboard(
                  context, path_operations.basename(widget.singleItem.path));
            },
            child: Text(
              path_operations.basename(widget.singleItem.path),
              style: h4TextStyle.copyWith(color: Colors.white),
            ),
          ),
          VSpace(),
          DetailItem(
            title: 'Path: ',
            value: widget.singleItem.path,
          ),
          VSpace(factor: .5),
          DetailItem(
            title: 'Size: ',
            value: handleConvertSize(size ?? 0),
            valueColor: kInActiveTextColor,
          ),
          VSpace(factor: .5),
          DetailItem(
            title: 'Modified: ',
            value: DateFormat('yyyy-MM-dd   hh:mmaa')
                .format(widget.singleItem.modified),
            valueColor: kInActiveTextColor,
          ),
        ],
      ),
    );
  }
}
