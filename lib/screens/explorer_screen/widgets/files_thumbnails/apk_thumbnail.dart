// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/isolates/file_thumb_isolates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApkThumbnail extends StatefulWidget {
  final bool sharingFile;
  final String filePath;

  const ApkThumbnail({
    super.key,
    required this.filePath,
    required this.sharingFile,
  });

  @override
  State<ApkThumbnail> createState() => _ApkThumbnailState();
}

class _ApkThumbnailState extends State<ApkThumbnail> {
  String? thumbPath;
  //? to set the state for the image thumbnail
  void setThumbnail(String path) {
    if (mounted) {
      setState(() {
        thumbPath = path;
      });
    }
  }

  void runCreateAPKThumbnail() async {
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        if (!mounted) return;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await getFileThumbnail(
            widget.filePath,
            setThumbnail,
            FileType.apk,
          );
          thumbProvider.decrementCompressing();
        } else {
          Future.delayed(Duration(milliseconds: 400)).then((value) {
            runCreateAPKThumbnail();
          });
        }
      },
    );
  }

  @override
  void initState() {
    if (!widget.sharingFile) runCreateAPKThumbnail();

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
            fadeInDuration: thumbnailFadeDuration,
            fadeOutDuration: thumbnailFadeDuration,
            width: largeIconSize,
            height: largeIconSize,
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            placeholderFit: BoxFit.cover,
            placeholder: AssetImage('assets/ext_icons/icons_1/apk.png'),
            image: FileImage(File(thumbPath!)),
          );
  }
}
