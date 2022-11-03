// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

int getFolderChildrenNumber(String path) {
  Directory directory = Directory(path);
  return directory.listSync().length;
}

class ChildDirectoryItem extends StatefulWidget {
  final String fileName;
  final FileSystemEntity fileSystemEntity;
  const ChildDirectoryItem({
    super.key,
    required this.fileName,
    required this.fileSystemEntity,
  });

  @override
  State<ChildDirectoryItem> createState() => _ChildDirectoryItemState();
}

class _ChildDirectoryItemState extends State<ChildDirectoryItem> {
  int? childrenNumber;
  String? error;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      try {
        int cn = await compute(
            getFolderChildrenNumber, widget.fileSystemEntity.path);
        setState(() {
          childrenNumber = cn;
        });
      } catch (e) {
        try {
          setState(() {
            error = e.toString();
          });
        } catch (E) {
//
        }
      }
    });
    super.initState();
  }

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
                widget.fileName,
                style: h4LightTextStyle,
                overflow: TextOverflow.ellipsis,
              ),
              if (error == null)
                Text(
                  childrenNumber == null ? '...' : '$childrenNumber Items',
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
