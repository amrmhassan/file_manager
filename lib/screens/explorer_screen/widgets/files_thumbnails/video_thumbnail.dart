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

  @override
  void initState() {
    print(widget.path);
    File videoFile = File(widget.path);
    if (videoFile.existsSync()) {
      print('Video exists---------------------');
    }
    _controller = VideoPlayerController.file(File(widget.path));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largeIconSize,
      height: largeIconSize,
      child: VideoPlayer(
        _controller,
      ),
    );
    // return Image.asset(
    //   'assets/ext_icons/icons_1/video.png',
    //   width: largeIconSize,
    // );
  }
}
