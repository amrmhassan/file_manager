// ignore_for_file: prefer_const_constructors, dead_code

import 'dart:io';
import 'dart:isolate';

import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/providers/thumbnail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart' as fni;
import 'package:provider/provider.dart';

//? to run the compress image isolate and send messages
void runCompressIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((path) async {
    String compressedPath = await compressImageIsolate(path);
    sendPort.send(compressedPath);
  });
}

//? to compress image in isolate
Future<String> compressImageIsolate(String path) async {
  fni.ImageProperties properties =
      await fni.FlutterNativeImage.getImageProperties(path);
  int width = properties.width!;
  int height = properties.height!;

  double widthHeightRatio = width / height;

  int newWidth = (largeIconSize * 2).toInt();
  int newHeight = newWidth ~/ widthHeightRatio;

  File compressedFile = await fni.FlutterNativeImage.compressImage(
    path,
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

//? this will compress an image and check for it in sqlite
  Future<void> compressImage(String imagePath) async {
    try {
      var data = await DBHelper.getDataWhere(
        imgThumbnailPathTableName,
        pathString,
        imagePath,
        persistentDbName,
      );
      String thumbnail = data.first.values.last;
      File thumbFile = File(thumbnail);
      bool exists = thumbFile.existsSync();
      if (exists) {
        setThumbnail(thumbnail);
      } else {
        throw Exception('no thumb');
      }
    } catch (e) {
      ReceivePort receivePort = ReceivePort();
      SendPort sendPort = receivePort.sendPort;
      Isolate.spawn(runCompressIsolate, sendPort);
      sendPort.send(imagePath);
      receivePort.listen((compressedFilePath) async {
        try {
          await DBHelper.insert(
            imgThumbnailPathTableName,
            {
              pathString: imagePath,
              thumbnailStringPath: compressedFilePath,
            },
            persistentDbName,
          );
          setThumbnail(compressedFilePath);
        } catch (e) {
          // printOnDebug(e);
        }
      });
    }
  }

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
    Future.delayed(Duration.zero).then(
      (value) async {
        if (!mounted) return;
        var thumbProvider =
            Provider.of<ThumbnailProvider>(context, listen: false);
        bool allow = thumbProvider.allowMeToCompress;
        if (allow) {
          thumbProvider.incrementCompressing();
          await compressImage(widget.path);
          thumbProvider.decrementCompressing();
        } else {
          Future.delayed(Duration(milliseconds: 500)).then((value) {
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
