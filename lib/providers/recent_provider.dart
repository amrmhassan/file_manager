import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
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
    await _saveResultsToSqlite();
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
      String ext = getFileExtension(file.path);
      FileType fileType = getFileType(ext);

      if (path.contains('/cache')) {
        continue;
      }
      if (allowRecentItemsFromHiddenFiles && path.contains('/.')) {
        continue;
      }

      if (_addImage(path, fileType) && imagesFiles.length < recentItemsLimit) {
        imagesFiles.add(file);
      } else if (_addVideo(path, fileType) &&
          videosFiles.length < recentItemsLimit) {
        videosFiles.add(file);
      } else if (_addMusic(path, fileType) &&
          musicFiles.length < recentItemsLimit) {
        musicFiles.add(file);
      } else if (_addApk(path, fileType) &&
          apkFiles.length < recentItemsLimit) {
        apkFiles.add(file);
      } else if (_addArchives(path, fileType) &&
          archivesFiles.length < recentItemsLimit) {
        archivesFiles.add(file);
      } else if (_addDocs(path, fileType) &&
          docsFiles.length < recentItemsLimit) {
        docsFiles.add(file);
      }

      // these recent doesn't depend on file type
      if (_addDownloads(path) && downloadsFiles.length < recentItemsLimit) {
        downloadsFiles.add(file);
      }
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
    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: imagesRecentFilesTableName,
    );
    for (var image in data) {
      imagesFiles.add(LocalFileInfo.fromJSON(image));
    }
  }

  Future loadVideos() async {
    if (videosFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: videosRecentFilesTableName,
      databaseName: tempDbName,
    );
    for (var video in data) {
      videosFiles.add(LocalFileInfo.fromJSON(video));
    }
  }

  Future loadMusic() async {
    if (musicFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: musicRecentFilesTableName,
    );
    for (var music in data) {
      musicFiles.add(LocalFileInfo.fromJSON(music));
    }
  }

  Future loadApk() async {
    if (apkFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: apkRecentFilesTableName,
    );
    for (var apk in data) {
      apkFiles.add(LocalFileInfo.fromJSON(apk));
    }
  }

  Future loadArchives() async {
    if (archivesFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: archivesRecentFilesTableName,
    );
    for (var apk in data) {
      archivesFiles.add(LocalFileInfo.fromJSON(apk));
    }
  }

  Future loadDocs() async {
    if (docsFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: docsRecentFilesTableName,
    );
    for (var doc in data) {
      docsFiles.add(LocalFileInfo.fromJSON(doc));
    }
  }

  Future loadDownloads() async {
    if (downloadsFiles.isNotEmpty) return;

    var data = await DBHelper.getDataLimit(
      orderProp: createdAtString,
      table: downloadsRecentFilesTableName,
    );
    for (var downloadFile in data) {
      downloadsFiles.add(LocalFileInfo.fromJSON(downloadFile));
    }
  }

//# save data to sqlite
  Future<void> _saveResultsToSqlite() async {
    for (var imageFile in imagesFiles) {
      var jsonOBJ = imageFile.toJSON();
      await DBHelper.insert(imagesRecentFilesTableName, jsonOBJ);
    }

    for (var video in videosFiles) {
      var jsonOBJ = video.toJSON();
      await DBHelper.insert(videosRecentFilesTableName, jsonOBJ);
    }
    for (var music in musicFiles) {
      var jsonOBJ = music.toJSON();
      await DBHelper.insert(musicRecentFilesTableName, jsonOBJ);
    }
    for (var apk in apkFiles) {
      var jsonOBJ = apk.toJSON();
      await DBHelper.insert(apkRecentFilesTableName, jsonOBJ);
    }
    for (var archive in archivesFiles) {
      var jsonOBJ = archive.toJSON();
      await DBHelper.insert(archivesRecentFilesTableName, jsonOBJ);
    }
    for (var doc in docsFiles) {
      var jsonOBJ = doc.toJSON();
      await DBHelper.insert(docsRecentFilesTableName, jsonOBJ);
    }
    for (var downloadFile in downloadsFiles) {
      var jsonOBJ = downloadFile.toJSON();
      await DBHelper.insert(downloadsRecentFilesTableName, jsonOBJ);
    }
  }
}
