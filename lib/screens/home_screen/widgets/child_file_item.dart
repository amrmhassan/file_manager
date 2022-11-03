// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/screens/home_screen/isolates/load_folder_children_isolates.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class ChildFileItem extends StatelessWidget {
  final List<String> fileName;
  final FileSystemEntityInfo fileSystemEntityInfo;
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
          getFileTypeIcon(
              path.extension(fileSystemEntityInfo.fileSystemEntity.path)),
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
              Text(
                getFileSize(),
                style: h4TextStyleInactive.copyWith(
                  color: kInactiveColor,
                  height: 1,
                ),
              ),
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

  String getFileSize() {
    int sizeInByte = fileSystemEntityInfo.size;
    String unit = '';
    double covertedSize = 0;
    if (sizeInByte < 1024) {
      covertedSize = sizeInByte * 1;
      unit = 'Byte';
    } else if (sizeInByte < 1024 * 1024) {
      covertedSize = sizeInByte.toKB;
      unit = 'KB';
    } else if (sizeInByte < 1024 * 1024 * 1024) {
      covertedSize = sizeInByte.toMB;
      unit = 'MB';
    } else {
      covertedSize = sizeInByte.toGB;
      unit = 'GB';
    }
    return '${double.parse(covertedSize.toStringAsFixed(2))}$unit';
  }
}
