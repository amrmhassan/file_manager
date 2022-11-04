import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/utils/files_utils.dart';

List<FileSystemEntity> getFixedEntityList(
    bool priotirizeFoldres, List<FileSystemEntity> viewedChildren) {
  List<FileSystemEntity> fixedEntities = [];
  if (sortAlphapitacally) {
    viewedChildren.sort(
      (a, b) => a.path.compareTo(b.path),
    );
  }
  if (priotirizeFoldres) {
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
