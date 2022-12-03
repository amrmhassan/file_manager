// ignore_for_file: dead_code, prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;
  double? vidWidth;

  double? vidHeight;
  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.path)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            vidWidth = _controller.value.size.width;
            vidHeight = _controller.value.size.height;
            // here the video info will be available
          });
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return vidHeight == null && vidWidth == null
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
                    child: VideoPlayer(
                      _controller,
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.5),
                    width: largeIconSize,
                    height: largeIconSize,
                  )
                ],
              ),
              Opacity(
                opacity: .7,
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
