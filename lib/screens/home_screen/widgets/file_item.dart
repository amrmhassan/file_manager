// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:explorer/analyzing_code/explorer_utils/scanning_utils.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class StorageItem extends StatelessWidget {
  final FileSystemEntity fileSystemEntity;
  final Function(FileSystemEntity f) onDirTapped;
  const StorageItem({
    super.key,
    required this.fileSystemEntity,
    required this.onDirTapped,
  });

  bool get isDir {
    return ScanningUtils().isDir(fileSystemEntity.path);
  }

  String fileName() {
    return path.basename(fileSystemEntity.path);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () {
        if (isDir) {
          onDirTapped(fileSystemEntity);
        }
      },
      borderRadius: 0,
      child: Column(
        children: [
          VSpace(factor: .5),
          PaddingWrapper(
            child: isDir
                ? DirectoryItem(
                    fileName: fileName(),
                    fileSystemEntity: fileSystemEntity,
                  )
                : FileItem(
                    fileName: fileName(),
                    fileSystemEntity: fileSystemEntity,
                  ),
          ),
          VSpace(factor: .5),
          HLine(
            thickness: 1,
            color: kInactiveColor.withOpacity(.1),
          ),
        ],
      ),
    );
  }
}

class DirectoryItem extends StatelessWidget {
  final String fileName;
  final FileSystemEntity fileSystemEntity;
  const DirectoryItem({
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

class FileItem extends StatelessWidget {
  final String fileName;
  final FileSystemEntity fileSystemEntity;
  const FileItem({
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
