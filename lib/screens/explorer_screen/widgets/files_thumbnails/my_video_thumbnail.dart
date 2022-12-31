// ignore_for_file: dead_code, prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/isolates/file_thumb_isolates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyVideoThumbnail extends StatefulWidget {
  final String path;
  const MyVideoThumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<MyVideoThumbnail> createState() => _MyVideoThumbnailState();
}

class _MyVideoThumbnailState extends State<MyVideoThumbnail> {
  String? thumbPath;

  void setThumbnail(String thumb) {
    if (mounted) {
      setState(() {
        thumbPath = thumb;
      });
    }
  }

  void runVideoThumbnail() async {
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        if (!mounted) return;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await getFileThumbnail(
            widget.path,
            setThumbnail,
            FileType.video,
          );
          thumbProvider.decrementCompressing();
        } else {
          Future.delayed(Duration(milliseconds: 400)).then((value) {
            runVideoThumbnail();
          });
        }
      },
    );
  }

  @override
  void initState() {
    runVideoThumbnail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return thumbPath == null
        ? Image.asset(
            'assets/ext_icons/icons_1/video.png',
            width: largeIconSize,
          )
        : Container(
            clipBehavior: Clip.hardEdge,
            width: largeIconSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(smallBorderRadius),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: largeIconSize,
                      height: largeIconSize,
                      child: FadeInImage(
                        fadeInDuration: thumbnailFadeDuration,
                        fadeOutDuration: thumbnailFadeDuration,
                        width: largeIconSize,
                        height: largeIconSize,
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        placeholderFit: BoxFit.cover,
                        placeholder:
                            AssetImage('assets/ext_icons/icons_1/video.png'),
                        image: FileImage(File(thumbPath!)),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(.1),
                      width: largeIconSize,
                      height: largeIconSize,
                    )
                  ],
                ),
                Opacity(
                  opacity: .5,
                  child: Image.asset(
                    'assets/icons/play.png',
                    color: Colors.white,
                    width: largeIconSize / 1.8,
                  ),
                )
              ],
            ),
          );
  }
}
