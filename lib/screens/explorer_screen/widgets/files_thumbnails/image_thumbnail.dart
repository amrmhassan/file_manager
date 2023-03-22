// ignore_for_file: prefer_const_constructors, dead_code

// normal image 3024 * 4032
// normal image 3024 * 4032
// rotated image 4032 * 3024
// rotated image 4032 * 3024

// so rotated images width is height than their height
import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/isolates/file_thumb_isolates.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ImageThumbnail extends StatefulWidget {
  const ImageThumbnail({
    Key? key,
    required this.path,
    required this.sharingFile,
  }) : super(key: key);

  final String path;
  final bool sharingFile;

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
        String currentActiveDirPath =
            Provider.of<ExplorerProvider>(context, listen: false)
                .currentActiveDir
                .path;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        String tempDirPath = (await getTemporaryDirectory()).path;
        //* to prevent from creating thumbnails in the temp directory and just view the original image
        if (currentActiveDirPath == tempDirPath) {
          setThumbnail(widget.path);
          return;
        }
        //* to create a new image thumbnail or to retrieve the saved one by calling the createFileThumbnail Method
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await getFileThumbnail(
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
    if (!widget.sharingFile) runCompress();
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
              fadeInDuration: thumbnailFadeDuration,
              fadeOutDuration: thumbnailFadeDuration,
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
