// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class ChildFileItem extends StatelessWidget {
  final List<String> fileName;
  final StorageItemModel fileSystemEntityInfo;
  const ChildFileItem({
    super.key,
    required this.fileName,
    required this.fileSystemEntityInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          getFileTypeIcon(path.extension(fileSystemEntityInfo.path)),
          width: largeIconSize,
        ),
        HSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName.first,
                style: h4LightTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
              FutureBuilder<FileStat>(
                  future: File(fileSystemEntityInfo.path).stat(),
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
                                  DateFormat('yyyy-MM-dd')
                                      .format(snapshot.data!.modified),
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
          fileName.last,
          style: h4TextStyleInactive.copyWith(
            color: kInActiveTextColor.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}
