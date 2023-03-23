import 'dart:ui';

import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/isolates/folder_children_isolate_class.dart';
import 'package:explorer/models/types.dart';
import 'package:path/path.dart' as path_operations;

//! this took 22 seconds(very bad implementation), so cancel it
class AdvancedStorageAnalyzerV2 extends AdvancedStorageAnalyzer {
  AdvancedStorageAnalyzerV2(super.path);

  @override
  Future<void> getDirChildren({
    required String path,
    required VoidCallback onAllDone,
    required Function(LocalFolderInfo localFolderInfo) onFolderDone,
    Function(LocalFileInfo localFileInfo)? onFileScanned,
    required Function(Object e, Directory directory) onError,
  }) async {
    List<LocalFileInfo> folderFilesChildren = [];

    var res = getAllFolderChildren(path, onError);
    for (var entity in res) {
      File file = File(entity);
      allEntitiesPaths.add(entity);
      if (file.existsSync()) {
        FileStat stat = File(entity).statSync();
        LocalFileInfo fileInfo = LocalFileInfo(
          size: stat.size,
          parentPath: file.parent.path,
          path: file.path,
          modified: stat.modified,
          accessed: stat.accessed,
          changed: stat.changed,
          entityType: EntityType.file,
          fileBaseName: path_operations.basename(file.path),
          ext: getFileExtension(file.path),
        );
        allFilesSize += stat.size;
        folderFilesChildren.add(fileInfo);
        filesInfo.add(fileInfo);
        if (onFileScanned != null) {
          onFileScanned(fileInfo);
        }
      } else {
        Directory directory = Directory(entity);
        FileStat stat = directory.statSync();
        LocalFolderInfo currentScannedFolderInfo = LocalFolderInfo(
          parentPath: directory.parent.path,
          path: directory.path,
          modified: stat.modified,
          accessed: stat.accessed,
          changed: stat.changed,
          entityType: EntityType.folder,
          dateCaptured: DateTime.now(),
        );
        //* adding the current scanned folder to the global list
        foldersInfo.add(currentScannedFolderInfo);
        onFolderDone(currentScannedFolderInfo);
      }
    }
    onAllDone();
  }

  List<String> getAllFolderChildren(
      String folderPath, Function(Object e, Directory directory) onError) {
    return FolderChildrenIsolate.getFolderChildrenAsPathsRecursive(
      folderPath,
      onError: (e, p) {
        Directory dir = Directory(p);
        LocalFolderInfo systemFolderInfo = LocalFolderInfo(
          parentPath: dir.parent.path,
          path: dir.path,
          modified: DateTime.now(),
          accessed: DateTime.now(),
          changed: DateTime.now(),
          entityType: EntityType.folder,
          dateCaptured: DateTime.now(),
          size: 0,
        );
        foldersInfo.add(systemFolderInfo);
        onError(e, Directory(p));
        logger.e(e);
      },
    );
  }
}
