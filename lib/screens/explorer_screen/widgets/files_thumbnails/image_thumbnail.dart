// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as adv_image;
import 'package:path/path.dart' as path_operations;

Future<File> compressImage(Map<String, String> data) async {
  String imagePath = data['imagePath']!;
  String tempDirPath = data['tempDirPath']!;
  String imageBaseName = path_operations.basename(imagePath);
  Directory tempDir = Directory(tempDirPath);
  String imageFinalPath = '${tempDir.path}/$imageBaseName';
  File testFile = File(imageFinalPath);
  if (testFile.existsSync()) {
    return testFile;
  } else {
    File imageFile = File(imagePath);
    var image = adv_image.decodeImage(imageFile.readAsBytesSync())!;
    var thumbnail = adv_image.copyResize(image, width: 120);
    var thumbnailFile = File.fromRawPath(thumbnail.getBytes());
    var finalRes = await thumbnailFile.copy(imageFinalPath);

    return finalRes;
  }
}

class ImageThumbnail extends StatelessWidget {
  const ImageThumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: largeIconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      child: FadeInImage(
        placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
        fit: BoxFit.cover,
        image: ResizeImage.resizeIfNeeded(
          largeIconSize.toInt(),
          largeIconSize.toInt(),
          FileImage(
            File(path),
          ),
        ),
      ),
    );
  }
}
