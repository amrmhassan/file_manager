import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/image_thumbnail.dart';
import 'package:explorer/screens/explorer_screen/widgets/files_thumbnails/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class FileThumnail extends StatelessWidget {
  final String path;
  const FileThumnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  String getFileExt() {
    return path_operations.extension(path);
  }

  @override
  Widget build(BuildContext context) {
    FileType fileType = getFileType(getFileExt());

    return Builder(
      builder: (context) {
        return fileType == FileType.image
            ? ImageThumbnail(path: path)
            : fileType == FileType.video
                ? MyVideoThumbnail(path: path)
                : Image.asset(
                    getFileTypeIcon(getFileExt()),
                    width: largeIconSize,
                  );
      },
    );
  }
}
