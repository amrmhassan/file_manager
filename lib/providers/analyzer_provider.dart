import 'dart:isolate';
import 'package:disk_space/disk_space.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/hive/hive_collections.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/screen_utils/recent_screen_utils.dart';
import 'package:path/path.dart' as path_operations;

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/isolates/analyzing_isolates.dart';
import 'package:flutter/cupertino.dart';

//! don't load all folders info to the state when loading the app
//! just load the extensions info to the state to save memory
//! and for the folders just load the current opened folder children with their info
//! for the sizes explorer load normal explorer list but with the sizes futures, and the children list will need a parameter of sizesExplorer (bool)

class AnalyzerProvider extends ChangeNotifier {
  //? these data will be available after running the analyzer without closing the app
  bool _loading = false;

  bool get loading => _loading;

  bool _savingInfoToSqlite = false;

  bool get savingInfoToSqlite => _savingInfoToSqlite;

  String _currentFolder = '';

  String get currentAnalyzedFolder => _currentFolder;

  AdvancedStorageAnalyzer? _advancedStorageAnalyzer;

  AdvancedStorageAnalyzer? get advancedStorageAnalyzer =>
      _advancedStorageAnalyzer;

  StorageAnalyzerV4? _storageAnalyzerV4;

  StorageAnalyzerV4? get storageAnalyzerV4 => _storageAnalyzerV4;

  //? these data will be loaded from the sqlite after reopening the app or after running the analyzer
  List<LocalFolderInfo> _foldersInfo = [];

  List<LocalFolderInfo>? get foldersInfo => _foldersInfo;

  List<ExtensionInfo>? _allExtensionsInfo;

  List<ExtensionInfo>? get allExtensionInfo => _allExtensionsInfo;

  AnalyzerReportInfoModel? reportInfo;

  //? last date the user performed (analyzing storage)

  DateTime? lastAnalyzingReportDate;
  Future<void> _setLastAnalyzingDate() async {
    DateTime now = DateTime.now();
    await SharedPrefHelper.setString(
        lastAnalyzingReportDateKey, now.toIso8601String());
    lastAnalyzingReportDate = now;
    notifyListeners();
  }

  //? to load the last analyzing date from the shared prefs
  Future<void> _loadLastAnalyzingDate() async {
    String? date = await SharedPrefHelper.getString(lastAnalyzingReportDateKey);
    if (date != null) {
      lastAnalyzingReportDate = DateTime.parse(date);
      notifyListeners();
    }
  }

  //? load data to the app

  Future<void> loadInitialAppData(RecentProvider recentProvider) async {
    await _loadLastAnalyzingDate();
    await _getReportInfo();
    await _getSavedExtensionsInfo();
    calcSections(_allExtensionsInfo, (sec) {
      recentProvider.setSections(sec);
    }, this);
  }

  //? get dir info by path

  Future<LocalFolderInfo?> getDirInfoByPath(String path) async {
    try {
      LocalFolderInfo localFolderInfo =
          _foldersInfo.firstWhere((element) => element.path == path);
      return localFolderInfo;
    } catch (e) {
      try {
        //* load its data form db if it doesn't exist in the local state
        // var data = await DBHelper.getDataWhere(
        //   localFolderInfoTableName,
        //   pathString,
        //   path,
        // );
        LocalFolderInfo localFolderInfo =
            (await HiveBox.localFolderInfoTableName).values.first;
        _foldersInfo.add(localFolderInfo);
        return localFolderInfo;
      } catch (e) {
        return null;
      }
    }
  }

  //? to clear all saved data from the RAM

  void clearAllData() {
    _currentFolder = '';
    _advancedStorageAnalyzer = null;
    _storageAnalyzerV4 = null;
    notifyListeners();
  }

  //? to start analyzing storage

  Future<void> handleAnalyzeEvent(RecentProvider recentProvider) async {
    logger.i('analyzing storage');
    // _loading = true;
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    _loading = true;
    _currentFolder = 'Starting...';
    notifyListeners();
    Isolate isolate = await Isolate.spawn(
      (message) => runAnalyzeStorageIsolate(message),
      {
        'sendPort': sendPort,
        'parentPath': initialDirs
            .where(
              (element) => element.path != initialDirs.first.path,
            )
            .first
            .path,
      },
    );
    receivePort.listen(
      (message) async {
        if (message is AdvancedStorageAnalyzer) {
          //* here is the data of the finished results
          _currentFolder = 'Analyzing Data...';
          _advancedStorageAnalyzer = message;
          notifyListeners();
        } else if (message is LocalFolderInfo) {
          //* here run the code with finishing a folder
          _currentFolder = path_operations.basename(message.path);
          notifyListeners();
        } else if (message is StorageAnalyzerV4) {
          //* here getting the folders info with sizes
          _storageAnalyzerV4 = message;
          _currentFolder = '';
          _foldersInfo = message.allFolderInfoWithSize;
          _allExtensionsInfo = message.allExtensionsInfo;
          //? if we reached here this mean the storage analyzer report done successfully
          await tempCollection.deleteCollection();
          await _saveReportInfo();
          calcSections(_allExtensionsInfo, (sec) {
            recentProvider.setSections(sec);
          }, this);
          await _setLastAnalyzingDate();
          await _handleSaveRecentFiles(recentProvider);
          await _saveResultsToSqlite();
          await _saveAllFilesFoldersInfo();
          isolate.kill();
          _loading = false;
        } else if (message is int) {
          printOnDebug('Analyzing Time : ${message / 1000} Second');
        } else if (message is! SendPort) {
          //? here handle extensions
          // throw Exception(message);
        }
      },
    );
  }

  Future<void> _saveAllFilesFoldersInfo() async {
    try {
      // all files info box
      var filesInfoBox = (await HiveBox.allFilesInfoTableName);
      await filesInfoBox.clear();
      await filesInfoBox
          .addAll(_storageAnalyzerV4!.allFilesInfo.map((e) => e.path));

      // all folders info box
      var foldersInfoBox = (await HiveBox.allFoldersInfoTableName);
      await foldersInfoBox.clear();
      await foldersInfoBox
          .addAll(_storageAnalyzerV4!.allFoldersInfo.map((e) => e.path));
      // logger.i(
      //     'all folders info length is ${_storageAnalyzerV4!.allFoldersInfo.length}');
      // logger.i(
      // 'all folders info length from the box is ${foldersInfoBox.values.length}');
    } catch (e) {
      logger.e(e);
    }
  }

  //? handle save recent files
  Future _handleSaveRecentFiles(RecentProvider recentProvider) async {
    await recentProvider.initialize(_storageAnalyzerV4!);
  }

  //? save data to sqlite
  Future<void> _saveResultsToSqlite() async {
    _savingInfoToSqlite = true;
    notifyListeners();
    await _saveExtensionsInfo();
    await _saveFolderSizes();
    _savingInfoToSqlite = false;
    notifyListeners();
  }

  //? save extensions info to sqlite
  Future<void> _saveExtensionsInfo() async {
    (await HiveBox.extensionInfoTableName)
        .addAll(storageAnalyzerV4!.allExtensionsInfo);
    // for (var extension in storageAnalyzerV4!.allExtensionsInfo) {
    //   await DBHelper.insert(extensionInfoTableName, extension.toJSON());
    // }
  }

  //? save folders sizes to sqlite
  Future<void> _saveFolderSizes() async {
    (await HiveBox.localFolderInfoTableName)
        .addAll(storageAnalyzerV4!.allFolderInfoWithSize);
    // for (var folderInfo in storageAnalyzerV4!.allFolderInfoWithSize) {
    //   await DBHelper.insert(
    //     localFolderInfoTableName,
    //     folderInfo.toJSON(),
    //   );
    // }
  }

  //? get saved extensions info
  Future<void> _getSavedExtensionsInfo() async {
    try {
      // var data = await DBHelper.getData(extensionInfoTableName);
      // List<ExtensionInfo> ei =
      //     data.map((e) => ExtensionInfo.fromJSON(e)).toList();
      _allExtensionsInfo = [
        ...(await HiveBox.extensionInfoTableName).values.toList().cast()
      ];
      notifyListeners();
    } catch (e) {
      printOnDebug(e.toString());
    }
  }

  //? save the report info
  Future<void> _saveReportInfo() async {
    AnalyzerReportInfoModel analyzerReportInfoModel = AnalyzerReportInfoModel(
      dateDone: DateTime.now(),
      folderCount: _storageAnalyzerV4!.allFolderInfoWithSize.length,
      filesCount: _storageAnalyzerV4!.allFilesInfo.length,
      extensionsCount: 0,
      totalFilesSize: _advancedStorageAnalyzer!.allFilesSize,
    );
    reportInfo = analyzerReportInfoModel;
    notifyListeners();
    var box = await HiveBox.analyzerReportInfo;
    await box.add(analyzerReportInfoModel);
  }

  //? load report info
  Future<void> _getReportInfo() async {
    if (lastAnalyzingReportDate != null) {
      try {
        var box = await HiveBox.analyzerReportInfo;
        reportInfo = box.values.first;
        notifyListeners();
      } catch (e) {
        printOnDebug('No report info yet');
      }
    }
  }

  //? get total storage size

  Future<int> getTotalDiskSpace() async {
    return getTotalDiskSpaceTemp();
  }

  //? get free storage size

  Future<int> getFreeDiskSpace() async {
    return getFreeDiskSpaceTemp();
  }

  //? get apps storage size

  Future<int> getAppsDiskSpace(int totalFilesSize) async {
    int total = await getTotalDiskSpace();
    int free = await getFreeDiskSpace();
    int files = totalFilesSize;
    return total - free - files;
  }
}

Future<int> getTotalDiskSpaceTemp() async {
  return ((await DiskSpace.getTotalDiskSpace ?? 0) * 1024 * 1024).toInt();
}

Future<int> getFreeDiskSpaceTemp() async {
  return ((await DiskSpace.getFreeDiskSpace ?? 0) * 1024 * 1024).toInt();
}
