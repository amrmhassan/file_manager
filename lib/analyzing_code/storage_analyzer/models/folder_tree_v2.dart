import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';

import '../../globals/files_folders_operations.dart';
import 'extension_count.dart';

class FolderTreeV2 {
  List<FolderTreeV2?> folderTree;
  String path;
  List<LocalFileInfo> files;

  FolderTreeV2({
    required this.path,
    required this.folderTree,
    required this.files,
  });

  //? to add a file info to the folder tree
  void addFileInfo(LocalFileInfo f) {
    files.add(f);
  }

  //? add a new folder tree
  void addFolderTree(FolderTreeV2? f) {
    folderTree.add(f);
  }

  //? get files size
  int get filesSize {
    return files.fold(
        0, (previousValue, element) => previousValue + element.size);
  }

//? to get the total size
  int get totalSize {
    int ts = filesSize;
    for (var folder in folderTree) {
      int fs = folder?.totalSize ?? 0;
      ts += fs;
    }
    return ts;
  }

  //? to get the total files length
  int get totalFilesLength {
    int totalFiles = files.length;
    for (var folder in folderTree) {
      int folderFiles = folder?.totalFilesLength ?? 0;
      totalFiles += folderFiles;
    }
    return totalFiles;
  }

//? get all files of the folder even the multi level children
  List<LocalFileInfo> get getAllFiles {
    List<LocalFileInfo> totalFiles = [...files];
    for (var folder in folderTree) {
      List<LocalFileInfo> folderFiles = folder?.getAllFiles ?? [];
      totalFiles.addAll(folderFiles);
    }
    return totalFiles;
  }

  //? to get all extensions info of a folder
  List<ExtensionInfo> get folderExtensionsInfo {
    List<ExtensionProfileV2?> extesntionsWithRepeat = [];

    List<LocalFileInfo> files = getAllFiles;
    for (var fileInfo in files) {
      String ext = getFileExtension(fileInfo.path);
      ExtensionProfileV2 ep = ExtensionProfileV2(ext: ext, fileInfo: fileInfo);
      extesntionsWithRepeat.add(ep);
    }
    extesntionsWithRepeat.sort(
      (a, b) {
        return a!.ext.compareTo(b!.ext);
      },
    );
    extesntionsWithRepeat.add(null);
    List<ExtensionInfo> extInfoList = [];
    List<String> iterateExt = [];
    int count = 0;
    int extSize = 0;
    ExtensionProfileV2? previousValue = extesntionsWithRepeat[0];
    for (var ext in extesntionsWithRepeat) {
      if (previousValue?.ext != ext?.ext) {
        iterateExt.add(previousValue!.ext);
        ExtensionInfo ec = ExtensionInfo(
          count: count,
          ext: previousValue.ext,
          size: extSize,
        );
        extInfoList.add(ec);
        extSize = ext?.fileInfo.size ?? 0;
        count = 1;
      } else if (ext != null) {
        extSize += ext.fileInfo.size;
        count++;
      }
      previousValue = ext;
    }
    return extInfoList;
  }
}

class ExtensionProfileV2 {
  final String ext;
  final LocalFileInfo fileInfo;

  const ExtensionProfileV2({
    required this.ext,
    required this.fileInfo,
  });
}
