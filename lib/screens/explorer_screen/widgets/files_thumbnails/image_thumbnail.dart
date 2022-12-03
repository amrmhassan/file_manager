// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:io';

import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:image/image.dart' as adv_image;
// import 'package:path/path.dart' as path_operations;

// Future<File> compressImage(Map<String, String> data) async {
//   String imagePath = data['imagePath']!;
//   String tempDirPath = data['tempDirPath']!;
//   String imageBaseName = path_operations.basename(imagePath);
//   Directory tempDir = Directory(tempDirPath);
//   String imageFinalPath = '${tempDir.path}/$imageBaseName';
//   File testFile = File(imageFinalPath);
//   if (testFile.existsSync()) {
//     return testFile;
//   } else {
//     File imageFile = File(imagePath);
//     var image = adv_image.decodeImage(imageFile.readAsBytesSync())!;
//     var thumbnail = adv_image.copyResize(image, width: 120);
//     var thumbnailFile = File.fromRawPath(thumbnail.getBytes());
//     var finalRes = await thumbnailFile.copy(imageFinalPath);

//     return finalRes;
//   }
// }

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
  int? imgWidth;
  int? imgHeight;
  void getImageInfo(String path) async {
    File image = File(path);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    if (mounted) {
      setState(() {
        imgHeight = decodedImage.height;
        imgWidth = decodedImage.width;
      });
    }
  }

  @override
  void initState() {
    getImageInfo(widget.path);
    super.initState();
  }

//? this is for reducing the dimensions of the image, but i don't like it , cause it enlarge the small image and tightens the large iamge
  int reduceDimension(int dimension, String title) {
    int width = imgWidth!;
    int height = imgHeight!;
    double divFactor = (width * height) / (100000 * 1.6);
    double initDim = dimension / divFactor;

    return initDim.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      width: largeIconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      child: FadeInImage(
        width: largeIconSize,
        height: largeIconSize,
        alignment: Alignment.topCenter,
        placeholderFit: BoxFit.cover,
        placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
        fit: BoxFit.cover,
        image: imgHeight == null && imgWidth == null
            ? AssetImage('assets/ext_icons/icons_1/image.png')
            : ResizeImage.resizeIfNeeded(
                reduceDimension(imgWidth!, 'Width'),
                reduceDimension(imgHeight!, 'Height'),
                FileImage(
                  File(widget.path),
                ),
              ),
      ),
    );
  }
}
