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
bool skipWhatsAppStatusFolder = true;
bool skipWhatsAppRecordsFolder = true;

class RecentProvider extends ChangeNotifier {
  late StorageAnalyzerV4 _storageAnalyzerV4;

  List<LocalFileInfo> imagesFiles = [];
  List<LocalFileInfo> videosFiles = [];
  List<LocalFileInfo> musicFiles = [];
  List<LocalFileInfo> apkFiles = [];
  List<LocalFileInfo> archivesFiles = [];
  List<LocalFileInfo> docsFiles = [];
  List<LocalFileInfo> downloadsFiles = [];

//? to start the class
  Future initialize(StorageAnalyzerV4 s) async {
    _storageAnalyzerV4 = s;
    List<LocalFileInfo> allFiles = _storageAnalyzerV4.allFilesInfo;
    allFiles.sort((a, b) => b.modified.compareTo(a.modified));

    // analyzeData(allFiles);
    _concludeRecentCategories(allFiles);
    await _saveResultsToSqlite();
  }

//! new method
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
    if (fileType == FileType.apk) {
      return true;
    }
    return false;
  }

  //? check archives
  bool _addArchives(String path, FileType fileType) {
    if (fileType == FileType.archive) {
      return true;
    }
    return false;
  }

  //? check docs
  bool _addDocs(String path, FileType fileType) {
    if (fileType == FileType.docs) {
      return true;
    }
    return false;
  }

  //? check downloads
  bool _addDownloads(String path) {
    if (path.toLowerCase().contains('download')) {
      return true;
    }
    return false;
  }

//! end of new method

// //? to start analyzing data
//   void analyzeData(List<LocalFileInfo> allFiles) {
//     getRecentImages(allFiles);
//     getRecentVideos(allFiles);
//     getRecentMusic(allFiles);
//     getRecentApk(allFiles);
//     getRecentArchives(allFiles);
//     getRecentDocs(allFiles);
//   }

// //# get data
// //? to get recent 100 images
//   void getRecentImages(List<LocalFileInfo> allFiles) {
//     imagesFiles.clear();
//     for (var file in allFiles) {
//       // this means that this is a hidden folder
//       if (skipWhatsAppStatusFolder && file.path.contains('/.Statuses')) {
//         continue;
//       }
//       if (imagesFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.image) {
//         imagesFiles.add(file);
//       }
//     }
//   }

// //? to get recent 100 videos
//   void getRecentVideos(List<LocalFileInfo> allFiles) {
//     videosFiles.clear();
//     for (var file in allFiles) {
//       if (skipWhatsAppStatusFolder && file.path.contains('/.Statuses')) {
//         continue;
//       }
//       if (videosFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.video) {
//         videosFiles.add(file);
//       }
//     }
//   }

// //? to get recent 100 music
//   void getRecentMusic(List<LocalFileInfo> allFiles) {
//     musicFiles.clear();
//     for (var file in allFiles) {
//       if (skipWhatsAppRecordsFolder &&
//           file.path.contains('/WhatsApp Voice Notes')) continue;
//       if (musicFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.audio) {
//         musicFiles.add(file);
//       }
//     }
//   }

// //? to get recent 100 apk
//   void getRecentApk(List<LocalFileInfo> allFiles) {
//     apkFiles.clear();
//     for (var file in allFiles) {
//       if (apkFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.apk) {
//         apkFiles.add(file);
//       }
//     }
//   }

// //? to get recent 100 archives
//   void getRecentArchives(List<LocalFileInfo> allFiles) {
//     archivesFiles.clear();
//     for (var file in allFiles) {
//       if (archivesFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.archive) {
//         archivesFiles.add(file);
//       }
//     }
//   }

// //? to get recent 100 docs
//   void getRecentDocs(List<LocalFileInfo> allFiles) {
//     docsFiles.clear();
//     for (var file in allFiles) {
//       if (docsFiles.length >= recentItemsLimit) {
//         break;
//       }
//       String ext = getFileExtension(file.path);
//       FileType fileType = getFileType(ext);
//       if (fileType == FileType.docs) {
//         docsFiles.add(file);
//       }
//     }
//   }

//# load data from sqlite
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

  Future loadMusic() async {
    musicFiles.clear();
    var data = await DBHelper.getData(musicRecentFilesTableName);
    for (var music in data) {
      musicFiles.add(LocalFileInfo.fromJSON(music));
    }
  }

  Future loadApk() async {
    apkFiles.clear();
    var data = await DBHelper.getData(apkRecentFilesTableName);
    for (var apk in data) {
      apkFiles.add(LocalFileInfo.fromJSON(apk));
    }
  }

  Future loadArchives() async {
    archivesFiles.clear();
    var data = await DBHelper.getData(archivesRecentFilesTableName);
    for (var apk in data) {
      archivesFiles.add(LocalFileInfo.fromJSON(apk));
    }
  }

  Future loadDocs() async {
    docsFiles.clear();
    var data = await DBHelper.getData(docsRecentFilesTableName);
    for (var doc in data) {
      docsFiles.add(LocalFileInfo.fromJSON(doc));
    }
  }

  Future loadDownloads() async {
    downloadsFiles.clear();
    var data = await DBHelper.getData(downloadsRecentFilesTableName);
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
