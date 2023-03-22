import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/screens/recent_screen/widget/segment_section.dart';
import 'package:flutter/material.dart';

int recentItemsLimit = 100;
bool skipHiddenFolders = false;
bool skipWhatsAppStatusFolder = true;
bool skipWhatsAppRecordsFolder = true;

class RecentProvider extends ChangeNotifier {
  bool loading = false;
  void setLoading(bool b) {
    loading = b;
    notifyListeners();
  }

  late StorageAnalyzerV4 _storageAnalyzerV4;

  List<LocalFileInfo> imagesFiles = [];
  List<LocalFileInfo> videosFiles = [];
  List<LocalFileInfo> musicFiles = [];
  List<LocalFileInfo> apkFiles = [];
  List<LocalFileInfo> archivesFiles = [];
  List<LocalFileInfo> docsFiles = [];
  List<LocalFileInfo> downloadsFiles = [];

//# storage sections
  List<SectionElement> sections = [];
  void setSections(List<SectionElement> sec) {
    sections = sec;
    notifyListeners();
  }

//? to start the class
  Future initialize(StorageAnalyzerV4 s) async {
    _storageAnalyzerV4 = s;
    List<LocalFileInfo> allFiles = _storageAnalyzerV4.allFilesInfo;
    allFiles.sort((a, b) => b.modified.compareTo(a.modified));

    _concludeRecentCategories(allFiles);
    // start watching for recent files folders
    _startListenForRecentFilesParents();
    // then save results
    await _saveResultsToSqlite();
  }

  void _removeRecentFile(String path) {
    // FileType fileType = getFileTypeFromPath(path);
    // if (fileType == FileType.image) {
    //   imagesFiles.removeWhere((element) => element.path == path);
    // } else if (fileType == FileType.video) {
    //   videosFiles.removeWhere((element) => element.path == path);
    // } else if (fileType == FileType.audio) {
    //   musicFiles.removeWhere((element) => element.path == path);
    // } else if (fileType == FileType.apk) {
    //   apkFiles.removeWhere((element) => element.path == path);
    // } else if (fileType == FileType.archive) {
    //   archivesFiles.removeWhere((element) => element.path == path);
    // } else if (fileType == FileType.docs) {
    //   docsFiles.removeWhere((element) => element.path == path);
    // }
    // if (path.toLowerCase().contains('download')) {
    //   // remove it also
    //   downloadsFiles.removeWhere((element) => element.path == path);
    // }
    // notifyListeners();
  }

  void _addRecentFile(LocalFileInfo file, [bool forceAdd = false]) async {
    String path = file.path;
    FileType fileType = getFileTypeFromPath(path);

    if (_addImage(path, fileType) &&
        (imagesFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.imagesRecentFilesTableName).add(file);
        imagesFiles.insert(0, file);
      } else {
        imagesFiles.add(file);
      }
    } else if (_addVideo(path, fileType) &&
        (videosFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.videosRecentFilesTableName).add(file);
        videosFiles.insert(0, file);
      } else {
        videosFiles.add(file);
      }
    } else if (_addMusic(path, fileType) &&
        (musicFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.musicRecentFilesTableName).add(file);
        musicFiles.insert(0, file);
      } else {
        musicFiles.add(file);
      }
    } else if (_addApk(path, fileType) &&
        (apkFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.apkRecentFilesTableName).add(file);
        apkFiles.insert(0, file);
      } else {
        apkFiles.add(file);
      }
    } else if (_addArchives(path, fileType) &&
        (archivesFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.archivesRecentFilesTableName).add(file);
        archivesFiles.insert(0, file);
      } else {
        archivesFiles.add(file);
      }
    } else if (_addDocs(path, fileType) &&
        (docsFiles.length < recentItemsLimit || forceAdd)) {
      if (forceAdd) {
        (await HiveBox.downloadsRecentFilesTableName).add(file);
        downloadsFiles.insert(0, file);
      } else {
        downloadsFiles.add(file);
      }
    }

    // these recent doesn't depend on file type
    if (_addDownloads(path) &&
        (downloadsFiles.length < recentItemsLimit || forceAdd)) {
      downloadsFiles.add(file);
      if (forceAdd) {
        (await HiveBox.downloadsRecentFilesTableName).add(file);
      }
    }
    if (forceAdd) {
      notifyListeners();
    }
  }

  //? get all types of files in this loop
  void _concludeRecentCategories(List<LocalFileInfo> allFiles) {
    // clearing lists first before adding to them
    imagesFiles.clear();
    videosFiles.clear();
    musicFiles.clear();
    apkFiles.clear();
    archivesFiles.clear();
    docsFiles.clear();
    // looping over all files
    for (var file in allFiles) {
      // getting file additional info
      String path = file.path;

      if (path.contains('/cache')) {
        continue;
      }
      if (allowRecentItemsFromHiddenFiles && path.contains('/.')) {
        continue;
      }

      _addRecentFile(file);
    }
  }

  //? check image
  bool _addImage(String path, FileType fileType) {
    if (imagesFiles.any((element) => element.path == path)) {
      return false;
    }
    if (skipWhatsAppStatusFolder && path.contains('/.Statuses')) {
      return false;
    }
    if (fileType == FileType.image) {
      return true;
    }
    return false;
  }

  //? check video
  bool _addVideo(String path, FileType fileType) {
    if (videosFiles.any((element) => element.path == path)) {
      return false;
    }
    if (skipWhatsAppStatusFolder && path.contains('/.Statuses')) {
      return false;
    }
    if (fileType == FileType.video) {
      return true;
    }
    return false;
  }

  //? check music
  bool _addMusic(String path, FileType fileType) {
    if (musicFiles.any((element) => element.path == path)) {
      return false;
    }
    if (skipWhatsAppRecordsFolder && path.contains('/WhatsApp Voice Notes')) {
      return false;
    }
    if (fileType == FileType.audio) {
      return true;
    }
    return false;
  }

  //? check apk
  bool _addApk(String path, FileType fileType) {
    if (apkFiles.any((element) => element.path == path)) {
      return false;
    }
    if (fileType == FileType.apk) {
      return true;
    }
    return false;
  }

  //? check archives
  bool _addArchives(String path, FileType fileType) {
    if (archivesFiles.any((element) => element.path == path)) {
      return false;
    }
    if (fileType == FileType.archive) {
      return true;
    }
    return false;
  }

  //? check docs
  bool _addDocs(String path, FileType fileType) {
    if (docsFiles.any((element) => element.path == path)) {
      return false;
    }
    if (fileType == FileType.docs) {
      return true;
    }
    return false;
  }

  //? check downloads
  bool _addDownloads(String path) {
    if (downloadsFiles.any((element) => element.path == path)) {
      return false;
    }
    if (path.toLowerCase().contains('download')) {
      return true;
    }
    return false;
  }

//# load data from sqlite

  Future loadImages() async {
    if (imagesFiles.isNotEmpty) return;

    imagesFiles = [
      ...(await HiveBox.imagesRecentFilesTableName).values.toList().cast()
    ];
    imagesFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadVideos() async {
    if (videosFiles.isNotEmpty) return;

    videosFiles = [
      ...(await HiveBox.videosRecentFilesTableName).values.toList().cast()
    ];
    videosFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadMusic() async {
    if (musicFiles.isNotEmpty) return;

    musicFiles = [
      ...(await HiveBox.musicRecentFilesTableName).values.toList().cast()
    ];
    musicFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadApk() async {
    if (apkFiles.isNotEmpty) return;

    apkFiles = [
      ...(await HiveBox.apkRecentFilesTableName).values.toList().cast()
    ];
    apkFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadArchives() async {
    if (archivesFiles.isNotEmpty) return;

    archivesFiles = [
      ...(await HiveBox.archivesRecentFilesTableName).values.toList().cast()
    ];
    archivesFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadDocs() async {
    if (docsFiles.isNotEmpty) return;

    docsFiles = [
      ...(await HiveBox.docsRecentFilesTableName).values.toList().cast()
    ];
    docsFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

  Future loadDownloads() async {
    if (downloadsFiles.isNotEmpty) return;

    downloadsFiles = [
      ...(await HiveBox.downloadsRecentFilesTableName).values.toList().cast()
    ];
    downloadsFiles.sort((b, a) => a.modified.compareTo(b.modified));
  }

//# save data to sqlite
  Future<void> _saveResultsToSqlite() async {
    (await HiveBox.imagesRecentFilesTableName).addAll(imagesFiles);

    (await HiveBox.videosRecentFilesTableName).addAll(videosFiles);

    (await HiveBox.musicRecentFilesTableName).addAll(musicFiles);

    (await HiveBox.apkRecentFilesTableName).addAll(apkFiles);

    (await HiveBox.archivesRecentFilesTableName).addAll(archivesFiles);

    (await HiveBox.docsRecentFilesTableName).addAll(docsFiles);

    (await HiveBox.downloadsRecentFilesTableName).addAll(downloadsFiles);
  }

  //# watching recent files parents
  final List<String> _foldersToWatch = [];
  final List<String> _watchedFolders = [];

  void _startListenForRecentFilesParents() {
    //
    for (var file in imagesFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in videosFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in musicFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in apkFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in archivesFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in docsFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    for (var file in downloadsFiles) {
      _addToFoldersToWatch(file.parentPath);
    }
    // after adding start watching
    _watchRecentFolders();
  }

  void _addToFoldersToWatch(String folderPath) {
    if (_foldersToWatch.any((element) => element == folderPath)) return;
    _foldersToWatch.add(folderPath);
  }

  void _watchRecentFolders() {
    for (var folderPath in _foldersToWatch) {
      _handleStartListenForSingleFolder(folderPath);
    }
  }

  void _handleStartListenForSingleFolder(String folderPath) {
    if (_watchedFolders.contains(folderPath)) return;
    Directory directory = Directory(folderPath);
    if (!directory.existsSync()) return;
    directory.watch().listen(_handleRecentFolderEvent);
    _watchedFolders.add(folderPath);
  }

  void _handleRecentFolderEvent(FileSystemEvent event) {
    if (event.isDirectory) {
      _handleStartListenForSingleFolder(event.path);
      logger.i('folder event');
    } else {
      var localFileInfo = LocalFileInfo.fromPath(event.path);

      //! 1=> add (copy)
      //! 4=> delete

      //! 8 => rename
      if (event.type == 1) {
        _addRecentFile(localFileInfo, true);
        logger.i('file added');
        //? add file to recent files
      } else if (event.type == 4) {
        _removeRecentFile(event.path);
        logger.i('file removed');
        //? just remove from the recent files
      }
      // else if (event.type == 8) {
      //   _addRecentFile(localFileInfo);
      //   //? just add the new file and the old one won't show automatically by the storage item widgets
      //   logger.i('file renamed');
      // }
    }
  }
}
