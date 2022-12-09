// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart' as fni;

Future<String> compressImage(String imagePath) async {
  fni.ImageProperties properties =
      await fni.FlutterNativeImage.getImageProperties(imagePath);
  int width = properties.width!;
  int height = properties.height!;

  double widthHeightRatio = width / height;

  int newWidth = (largeIconSize * 2).toInt();
  int newHeight = newWidth ~/ widthHeightRatio;

  File compressedFile = await fni.FlutterNativeImage.compressImage(
    imagePath,
    quality: 100,
    targetWidth: newWidth,
    targetHeight: newHeight,
  );

  return compressedFile.path;
}

class ImageThumbnail extends StatefulWidget {
  const ImageThumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  State<ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<ImageThumbnail> {
  String? compressedPath;
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) async {
        // String cP = await compute(compressImage, widget.path);
        String cP = await compressImage(widget.path);

        if (mounted) {
          setState(() {
            compressedPath = cP;
          });
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: largeIconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      child: compressedPath == null
          ? Image.asset(
              'assets/ext_icons/icons_1/image.png',
              width: largeIconSize,
              height: largeIconSize,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            )
          : FadeInImage(
              width: largeIconSize,
              height: largeIconSize,
              alignment: Alignment.topCenter,
              placeholderFit: BoxFit.cover,
              placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
              fit: BoxFit.cover,
              image: FileImage(File(compressedPath!)),
            ),
    );
  }
}
