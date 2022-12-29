import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  // PackageInfo? packageInfo;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     packageInfo = await PackageInfo.fromPlatform();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform();

    return Image.asset(
      'assets/ext_icons/icons_1/apk.png',
      width: largeIconSize,
      height: largeIconSize,
      alignment: Alignment.topCenter,
      fit: BoxFit.cover,
    );
  }
}
