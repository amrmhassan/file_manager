import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/ext_icons/icons_1/apk.png',
      width: largeIconSize,
      height: largeIconSize,
      alignment: Alignment.topCenter,
      fit: BoxFit.cover,
    );
  }
}
