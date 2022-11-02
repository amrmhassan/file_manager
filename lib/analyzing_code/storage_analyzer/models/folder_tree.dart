import '../../globals/files_folders_operations.dart';
import 'extension_count.dart';
import 'extension_profile.dart';
import 'file_info.dart';

class FolderTree with FilesFoldersOperations {
  List<FolderTree?> folderTree;
  String path;
  List<FileInfo> files;

  FolderTree({
    required this.path,
    required this.folderTree,
    required this.files,
  });

  //? to add a file info to the folder tree
  void addFileInfo(FileInfo f) {
    files.add(f);
  }

  //? add a new folder tree
  void addFolderTree(FolderTree? f) {
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
  List<FileInfo> get getAllFiles {
    List<FileInfo> totalFiles = [...files];
    for (var folder in folderTree) {
      List<FileInfo> folderFiles = folder?.getAllFiles ?? [];
      totalFiles.addAll(folderFiles);
    }
    return totalFiles;
  }

  //? to get all extensions info of a folder
  List<ExtensionInfo> get folderExtensionsInfo {
    List<ExtensionProfile?> extesntionsWithRepeat = [];

    List<FileInfo> files = getAllFiles;
    for (var fileInfo in files) {
      String ext = getFileExtension(fileInfo.fileSystemEntity.path);
      ExtensionProfile ep = ExtensionProfile(ext: ext, fileInfo: fileInfo);
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
    ExtensionProfile? previousValue = extesntionsWithRepeat[0];
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
