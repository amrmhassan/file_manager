import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

int recentItemsLimit = 100;
bool skipHiddenFolders = false;

class RecentProvider extends ChangeNotifier {
  late StorageAnalyzerV4 _storageAnalyzerV4;

  List<LocalFileInfo> imagesFiles = [];
  List<LocalFileInfo> videosFiles = [];
  List<LocalFileInfo> docsFiles = [];

//? to start the class
  Future initialize(StorageAnalyzerV4 s) async {
    _storageAnalyzerV4 = s;
    List<LocalFileInfo> allFiles = _storageAnalyzerV4.allFilesInfo;
    allFiles.sort((a, b) => b.modified.compareTo(a.modified));

    analyzeData(allFiles);
    await saveResultsToSqlite();
  }

//? to start analyzing data
  void analyzeData(List<LocalFileInfo> allFiles) {
    getRecentImages(allFiles);
    getRecentVideos(allFiles);
  }

//? to get recent 100 images
  void getRecentImages(List<LocalFileInfo> allFiles) {
    imagesFiles.clear();
    for (var file in allFiles) {
      if (imagesFiles.length >= recentItemsLimit) {
        break;
      }
      String ext = getFileExtension(file.path);
      FileType fileType = getFileType(ext);
      if (fileType == FileType.image) {
        imagesFiles.add(file);
      }
    }
  }

//? to get recent 100 videos
  void getRecentVideos(List<LocalFileInfo> allFiles) {
    videosFiles.clear();
    for (var file in allFiles) {
      if (videosFiles.length >= recentItemsLimit) {
        break;
      }
      String ext = getFileExtension(file.path);
      FileType fileType = getFileType(ext);
      if (fileType == FileType.video) {
        videosFiles.add(file);
      }
    }
  }

//! don't load all data all at once , just load each type when entering
  Future loadAllData() async {
    await loadImages();
    await loadVideos();
  }

  Future loadImages() async {
    imagesFiles.clear();
    var data = await DBHelper.getData(imagesRecentFilesTableName);
    for (var image in data) {
      imagesFiles.add(LocalFileInfo.fromJSON(image));
    }
  }

  Future loadVideos() async {
    videosFiles.clear();
    var data = await DBHelper.getData(videosRecentFilesTableName);
    for (var video in data) {
      videosFiles.add(LocalFileInfo.fromJSON(video));
    }
  }

  Future<void> saveResultsToSqlite() async {
    for (var imageFile in imagesFiles) {
      var jsonOBJ = imageFile.toJSON();
      await DBHelper.insert(imagesRecentFilesTableName, jsonOBJ);
    }

    for (var video in videosFiles) {
      var jsonOBJ = video.toJSON();
      await DBHelper.insert(videosRecentFilesTableName, jsonOBJ);
    }
  }
}
