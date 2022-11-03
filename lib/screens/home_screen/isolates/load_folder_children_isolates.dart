import 'dart:io';

import 'package:explorer/utils/general_utils.dart';

Future<List<FileSystemEntityInfo>> getFolderChildrenIsolate(String path) async {
  if (path.contains('Book')) {
    printOnDebug('Books');
  }
  Directory directory = Directory(path);
  var data = directory.listSync();
  List<FileSystemEntityInfo> childrenInfo = [];
  for (var entity in data) {
    int fSize = (await entity.stat()).size;
    childrenInfo.add(FileSystemEntityInfo(
      fileSystemEntity: entity,
      size: fSize,
    ));
  }

  return childrenInfo;
}

class FileSystemEntityInfo {
  final FileSystemEntity fileSystemEntity;
  final int size;

  const FileSystemEntityInfo({
    required this.fileSystemEntity,
    required this.size,
  });
}
