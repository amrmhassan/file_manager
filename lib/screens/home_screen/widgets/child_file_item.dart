// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class ChildFileItem extends StatelessWidget {
  final String fileName;
  final FileSystemEntity fileSystemEntity;
  const ChildFileItem({
    super.key,
    required this.fileName,
    required this.fileSystemEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/mp3.png',
          width: largeIconSize,
        ),
        HSpace(),
        Expanded(
          child: Text(
            fileName,
            style: h4LightTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
