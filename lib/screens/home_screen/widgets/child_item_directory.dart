// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class ChildDirectoryItem extends StatelessWidget {
  final String fileName;
  final FileSystemEntity fileSystemEntity;
  const ChildDirectoryItem({
    super.key,
    required this.fileName,
    required this.fileSystemEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                fileName,
                style: h4LightTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '300 Items',
                style: h5InactiveTextStyle.copyWith(height: 1),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Image.asset(
          'assets/icons/right-arrow.png',
          width: mediumIconSize,
          color: kInactiveColor,
        )
      ],
    );
  }
}
