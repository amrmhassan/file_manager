// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/screens/explorer_screen/widgets/file_size_with_date_modified.dart';
import 'package:flutter/material.dart';

class FileSize extends StatelessWidget {
  final bool sizesExplorer;
  final int? size;
  final DateTime? modified;
  final bool localFile;
  final String path;

  const FileSize({
    super.key,
    required this.sizesExplorer,
    required this.size,
    required this.modified,
    required this.path,
    required this.localFile,
  });

  @override
  Widget build(BuildContext context) {
    return sizesExplorer
        ? FileSizeWithDateModified(
            size: size,
            hasData: true,
            modified: modified,
          )
        : localFile
            ? FutureBuilder<FileStat>(
                future: File(path).stat(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int? fileSize = snapshot.data?.size;
                    return FileSizeWithDateModified(
                      size: fileSize,
                      hasData: snapshot.data != null,
                      modified:
                          fileSize == null ? null : snapshot.data!.modified,
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
                })
            : FileSizeWithDateModified(
                size: size,
                hasData: false,
                modified: null,
              );
  }
}
