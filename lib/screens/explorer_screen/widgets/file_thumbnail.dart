import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/image_thumbnail.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class FileThumbnail extends StatefulWidget {
  final String path;
  const FileThumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<FileThumbnail> {
//? to get the file extension
  String getFileExt() {
    return path_operations.extension(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    FileType fileType = getFileType(getFileExt());

    return Builder(
      builder: (context) {
        return fileType == FileType.image
            ? ImageThumbnail(
                path: widget.path,
              )
            : fileType == FileType.video
                ? MyVideoThumbnail(path: widget.path)
                : Image.asset(
                    getFileTypeIcon(getFileExt()),
                    width: largeIconSize,
                  );
      },
    );
  }
}
