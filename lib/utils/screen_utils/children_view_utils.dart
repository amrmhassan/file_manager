import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/utils/files_utils.dart';
import 'package:path/path.dart' as path;

List<FileSystemEntity> getFixedEntityList(
  List<FileSystemEntity> viewedChildren,
) {
  if (!showHiddenFiles) {
    viewedChildren = viewedChildren.where(
      (element) {
        return !path.basename(element.path).startsWith('.');
      },
    ).toList();
  }
  List<FileSystemEntity> fixedEntities = [];
  if (sortAlphapitacally) {
    viewedChildren.sort(
      (a, b) => a.path.compareTo(b.path),
    );
  }
  if (prioritizeFolders) {
    //* folders
    List<FileSystemEntity> fd = [
      ...viewedChildren.where((element) => isDir(element.path))
    ];
    //* files
    List<FileSystemEntity> fl = [
      ...viewedChildren.where((element) => isFile(element.path))
    ];

    fixedEntities.addAll(fd);
    fixedEntities.addAll(fl);
  } else {
    fixedEntities = [...viewedChildren];
  }

  return fixedEntities;
}
