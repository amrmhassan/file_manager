// ignore_for_file: dead_code, prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  Future<String> createVideoThumbnail(String sourcePath) async {
    MethodChannel channel =
        MethodChannel('amh.fileManager.com/video_thumbnail');
    Directory tempDir = await getTemporaryDirectory();
    String thumbnailPath =
        '${tempDir.path}/${basename(sourcePath).replaceAll(".mp4", ".jpg")}';
    String thumbnail = await channel.invokeMethod('handleVideo', {
      'filePath': sourcePath,
      'time': 0,
      'output': createNewPath(thumbnailPath),
    });
    return thumbnail;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      String thumb = await createVideoThumbnail(widget.path);
      if (mounted) {
        setState(() {
          thumbPath = thumb;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return thumbPath == null
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
                    child: Image.file(
                      File(thumbPath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
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
          );
  }
}
