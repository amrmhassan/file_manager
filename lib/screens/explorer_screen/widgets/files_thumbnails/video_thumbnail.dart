// ignore_for_file: dead_code, prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class MyVideoThumbnail extends StatelessWidget {
  final String path;
  const MyVideoThumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/ext_icons/icons_1/video.png',
      width: largeIconSize,
    );
  }
}
