// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/isolates/file_thumb_isolates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

//? to set the state for the image thumbnail
  void setThumbnail(String path) {
    if (mounted) {
      setState(() {
        compressedPath = path;
      });
    }
  }

//? to run the compress process if the limit doesn't exceeded else wait a 500ms then try again
  void runCompress() async {
    Future.delayed(Duration(milliseconds: 100)).then(
      (value) async {
        if (!mounted) return;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await createFileThumbnail(
            widget.path,
            setThumbnail,
            FileType.image,
          );
          thumbProvider.decrementCompressing();
        } else {
          Future.delayed(Duration(milliseconds: 400)).then((value) {
            runCompress();
          });
        }
      },
    );
  }

  @override
  void initState() {
    runCompress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //! the image.file is what fill the memory cause it doesn't clear after disposing, this error happens because the compress isolate returns the original image path, and the original images are very big and so many

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
          :
          //  Image(
          //     image: fileImage!,
          //     width: largeIconSize,
          //     height: largeIconSize,
          //     alignment: Alignment.topCenter,
          //     fit: BoxFit.cover,
          //   )
          //? this fade image cause memory leaks, don't use it in a large data cause it will consume the device memory
          FadeInImage(
              width: largeIconSize,
              height: largeIconSize,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
              placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
              image: FileImage(File(compressedPath!)),
            ),
    );
  }
}
