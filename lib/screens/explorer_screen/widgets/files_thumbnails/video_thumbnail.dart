// ignore_for_file: dead_code, prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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
  String? fileName;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      fileName = await VideoThumbnail.thumbnailFile(
        video: widget.path,
        imageFormat: ImageFormat.PNG,
        maxHeight: largeIconSize.toInt(),
        quality: 50,
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return fileName == null
        ? Image.asset(
            'assets/ext_icons/icons_1/video.png',
            width: largeIconSize,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: largeIconSize,
                    height: largeIconSize,
                    child: Image.file(File(fileName!)),
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
          );
  }
}
