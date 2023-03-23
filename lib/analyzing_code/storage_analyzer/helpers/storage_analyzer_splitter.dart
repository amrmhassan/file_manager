import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer_v2.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/isolates/folder_children_isolate_class.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class StorageAnalyzerSplitter {
  final String mainFolderPath;
  final SendPort sendPort;
  List<LocalFolderInfo> foldersInfo = [];
  List<LocalFileInfo> filesInfo = [];

  StorageAnalyzerSplitter(this.mainFolderPath, this.sendPort);

  Future<StorageAnalyzerV4> run() async {
    var firstGenChildren = Directory(mainFolderPath).listSync();
    return _handleRunParallelSearch(firstGenChildren);
  }

  Future<StorageAnalyzerV4> _handleRunParallelSearch(
    List<FileSystemEntity> firstGenChildren,
  ) async {
    Completer<StorageAnalyzerV4> completer = Completer<StorageAnalyzerV4>();
    List<String> completedSearches = [];
    List<String> parallelFoldersEntries = [];

    List<LocalFileInfo> allFilesInfo = [];
    List<LocalFolderInfo> allFoldersInfo = [];
    List<ExtensionInfo> allExtensionsInfo = [];
    List<LocalFolderInfo> allFolderInfoWithSize = [];

    for (FileSystemEntity entity in firstGenChildren) {
      FileStat stat = entity.statSync();
      if (stat.type == FileSystemEntityType.directory) {
        LocalFolderInfo localFolderInfo = LocalFolderInfo(
          parentPath: entity.parent.path,
          path: entity.path,
          modified: stat.modified,
          accessed: stat.accessed,
          changed: stat.changed,
          dateCaptured: DateTime.now(),
          entityType: EntityType.folder,
        );
        allFoldersInfo.add(localFolderInfo);
        parallelFoldersEntries.add(entity.path);
      } else {
        LocalFileInfo localFileInfo = LocalFileInfo(
          size: stat.size,
          parentPath: entity.parent.path,
          path: entity.path,
          modified: stat.modified,
          accessed: stat.accessed,
          changed: stat.changed,
          entityType: EntityType.file,
          fileBaseName: basename(entity.path),
          ext: getFileExtension(entity.path),
        );
        allFilesInfo.add(localFileInfo);
      }
    }

    print(parallelFoldersEntries.length);
    for (var folderEntry in parallelFoldersEntries) {
      compute(_advancedAnalyzerCaller, {
        'sendPort': sendPort,
        'parentPath': folderEntry,
      }).then((value) {
        print(value.allFilesInfo.length);
        allFilesInfo.addAll(value.allFilesInfo);
        allFoldersInfo.addAll(value.allFoldersInfo);
        allFolderInfoWithSize.addAll(value.allFolderInfoWithSize);
        allExtensionsInfo.addAll(value.allExtensionsInfo);

        completedSearches.add(folderEntry);
        if (completedSearches.length == parallelFoldersEntries.length) {
          StorageAnalyzerV4Creator storageAnalyzerV4Creator =
              StorageAnalyzerV4Creator(
            parentPath: mainFolderPath,
            allFilesInfo: allFilesInfo,
            allFoldersInfo: allFoldersInfo,
            allExtensionsInfo: allExtensionsInfo,
            allFolderInfoWithSize: allFolderInfoWithSize,
          );
          //! here gather the all info from above in one storage analyzer v4 object then send them
          completer.complete(storageAnalyzerV4Creator);
        }
      }).onError((error, stackTrace) {
        // print('$error $folderEntry ');
        completedSearches.add(folderEntry);
      });
    }
    return completer.future;
  }
}

Future<StorageAnalyzerV4> _advancedAnalyzerCaller(
  Map<String, dynamic> data,
) async {
  SendPort sendPort = data['sendPort'];
  String parentPath = data['parentPath'];

  var obj = AdvancedStorageAnalyzer(parentPath);

  print('before analyzing $parentPath');
  await obj.startAnalyzing(
    onAllDone: () {
      print('after analyzing $parentPath');
    },
    onFolderDone: ((localFolderInfo) {
      sendPort.send(localFolderInfo);
    }),
    onError: (e, dir) {
      // logger.e('$parentPath $e');
      sendPort.send(e);
    },
  );

  // print('$parentPath ${obj.allEntitiesPaths.length}');
  // sendPort.send(obj);
  StorageAnalyzerV4 storageAnalyzerV4 = StorageAnalyzerV4(
    allFilesInfo: obj.filesInfo,
    allFoldersInfo: obj.foldersInfo,
    parentPath: parentPath,
  );

  return storageAnalyzerV4;
}
