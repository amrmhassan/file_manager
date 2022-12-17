// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/isolates/image_thumb_isolates.dart';
import 'package:explorer/utils/general_utils.dart';
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
  FileImage? fileImage;
  String? compressedPath;

  StreamSubscription? streamSubscription;
  void setStreamSub(StreamSubscription s) {
    streamSubscription = s;
  }

  Isolate? isolate;
  void setIsolate(Isolate i) {
    isolate = i;
  }

//? to set the state for the image thumbnail
  void setThumbnail(String path) {
    if (mounted) {
      setState(() {
        compressedPath = path;
        fileImage = FileImage(File(compressedPath!));
      });
    }
  }

//? to run the compress process if the limit doesn't exceeded else wait a 500ms then try again
  void runCompress() async {
    Future.delayed(Duration.zero).then(
      (value) async {
        if (!mounted) return;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await compressImage(
              widget.path, setThumbnail, setStreamSub, setIsolate);
          thumbProvider.decrementCompressing();
        } else {
          Future.delayed(Duration(milliseconds: 200)).then((value) {
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
  void dispose() {
    streamSubscription?.cancel();
    isolate?.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //! the image.file is what fill the memory cause it doesn't clear after disposing
    if (compressedPath != null) {
      printOnDebug(compressedPath);
    }
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
            : Image(
                image: fileImage!,
                width: largeIconSize,
                height: largeIconSize,
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              )
        //? this fade image cause memory leaks, don't use it in a large data cause it will consume the device memory
        // FadeInImage(
        //     width: largeIconSize,
        //     height: largeIconSize,
        //     alignment: Alignment.topCenter,
        //     fit: BoxFit.cover,
        //     placeholderFit: BoxFit.cover,
        //     placeholder: AssetImage('assets/ext_icons/icons_1/image.png'),
        //     image: FileImage(File(compressedPath!)),
        //   ),
        );
  }
}
