// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ApkThumbnail extends StatefulWidget {
  final String filePath;
  const ApkThumbnail({
    super.key,
    required this.filePath,
  });

  @override
  State<ApkThumbnail> createState() => _ApkThumbnailState();
}

class _ApkThumbnailState extends State<ApkThumbnail> {
  String? thumbPath;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      String sourcePath = widget.filePath;
      MethodChannel channel =
          MethodChannel('amh.fileManager.com/video_thumbnail');
      Directory tempDir = await getTemporaryDirectory();
      String thumbnailPath = createNewPath(
          '${tempDir.path}/${basename(sourcePath).replaceAll(".apk", ".jpg")}');
      String apkThumbnail = await channel.invokeMethod('handleAPK', {
        'filePath': sourcePath,
        'output': thumbnailPath,
      });
      if (mounted) {
        setState(() {
          thumbPath = apkThumbnail;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return thumbPath == null
        ? Image.asset(
            'assets/ext_icons/icons_1/apk.png',
            width: largeIconSize,
            height: largeIconSize,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
          )
        : FadeInImage(
            width: largeIconSize,
            height: largeIconSize,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            placeholderFit: BoxFit.cover,
            placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
            image: FileImage(File(thumbPath!)),
          );
  }
}
