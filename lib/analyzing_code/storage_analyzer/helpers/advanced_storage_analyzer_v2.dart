// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

//! this is good implementation it takes about 4 seconds on my phone
// this class is to get all folder children recursive with some info
class AdvancedStorageAnalyzerV2 {
  String path;
  List<LocalFileInfo> filesInfo = [];
  List<LocalFolderInfo> foldersInfo = [];
  List<String> allEntitiesPaths = [];
  late int timeTaken;
  int allFilesSize = 0;

  List<String> waitingToScanFolders = [];

  AdvancedStorageAnalyzerV2(this.path);

//? start analyzing the folder
  Future<void> startAnalyzing({
    //* this will run after the whole folder is scanned
    //* this will run after a single folder gets scanned
    required Function(
      LocalFolderInfo localFolderInfo,
    )
        onFolderDone,
    Function(LocalFileInfo localFileInfo)? onFileScanned,
    required Function(Object e, Directory directory) onError,
  }) async {
    //* the single function of it scan the direct children, but it is recursive
    await getDirChildren(
      path: path,
      onFolderDone: onFolderDone,
      onFileScanned: onFileScanned,
      onError: onError,
    );
  }

//? scan single folder, but it is recursive so it scans the whole children and sub-children folders
  Future<void> getDirChildren({
    required String path,
    required Function(LocalFolderInfo localFolderInfo) onFolderDone,
    Function(LocalFileInfo localFileInfo)? onFileScanned,
    required Function(Object e, Directory directory) onError,
  }) async {
    Completer completer = Completer();
    //* the current folder unscarred sub-folders
    List<String> unscannedFoldersPath = [];
    //* the current folder children (files)
    List<LocalFileInfo> folderFilesChildren = [];
    //* the current folder directory object
    Directory dir = Directory(path);
    //* this will hold the current folder size
    try {
      //* getting stream with the current folder direct children
      var stream = dir.list();
      var streamSubscription =
          stream.listen((FileSystemEntity fileSystemEntity) async {
        allEntitiesPaths.add(fileSystemEntity.path);
        if (isFile(fileSystemEntity.path)) {
          //* getting the file info and add it to the global filesInfo list
          FileStat fileStat = await fileSystemEntity.stat();
          LocalFileInfo fileInfo = LocalFileInfo(
            size: fileStat.size,
            parentPath: fileSystemEntity.parent.path,
            path: fileSystemEntity.path,
            modified: fileStat.modified,
            accessed: fileStat.accessed,
            changed: fileStat.changed,
            entityType: EntityType.file,
            fileBaseName: path_operations.basename(fileSystemEntity.path),
            ext: getFileExtension(fileSystemEntity.path),
          );
          allFilesSize += fileStat.size;
          //* calling what getting new file info
          if (onFileScanned != null) {
            onFileScanned(fileInfo);
          }
          //* adding it to the local folder files List
          folderFilesChildren.add(fileInfo);
          //* adding it to the global files list
          filesInfo.add(fileInfo);
        } else {
          //* adding the folder path to the scan queue
          unscannedFoldersPath.add(fileSystemEntity.path);
          //* adding it to the waiting to scan folder list will help us know when the whole operation is totally finished
          waitingToScanFolders.add(fileSystemEntity.path);
        }
      });

      //* this will run after a single folder direct children are totally scanned
      streamSubscription.onDone(() async {
        //* getting the folder stat, and adding it to the global folders list
        FileStat currentScannedFolderStat = await dir.stat();
        LocalFolderInfo currentScannedFolderInfo = LocalFolderInfo(
          parentPath: dir.parent.path,
          path: dir.path,
          modified: currentScannedFolderStat.modified,
          accessed: currentScannedFolderStat.accessed,
          changed: currentScannedFolderStat.changed,
          entityType: EntityType.folder,
          dateCaptured: DateTime.now(),
        );
        //* adding the current scanned folder to the global list
        foldersInfo.add(currentScannedFolderInfo);
        onFolderDone(currentScannedFolderInfo);
        //* this will check if this done is the last done in the class life
        //* by using the waitingToScanFolders and checking if it empty
        bool firstDir = !waitingToScanFolders.remove(dir.path);
        bool allDone = !firstDir && waitingToScanFolders.isEmpty;
        if (allDone) {
          completer.complete();
        }

        //* this will be the recursive part of the method to scan all sub-folders to the ground
        for (var unscannedFolder in unscannedFoldersPath) {
          try {
            await getDirChildren(
              path: unscannedFolder,
              onFolderDone: onFolderDone,
              onFileScanned: onFileScanned,
              onError: onError,
            );
          } catch (e) {
            //
          }
        }
      });

      streamSubscription.onError((e) {
        onError(e, dir);
      });
    } catch (e) {
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
    }
    return completer.future;
  }
}
