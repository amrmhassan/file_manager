import 'dart:isolate';
import 'package:disk_space/disk_space.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/providers/analyzer_provider_abstract.dart';
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

class AnalyzerProvider extends ChangeNotifier
    implements AnalyzerProviderAbstract {
  //? these data will be available after running the analyzer without closing the app
  bool _loading = false;
  @override
  get loading => _loading;

  bool _savingInfoToSqlite = false;
  @override
  bool get savingInfoToSqlite => _savingInfoToSqlite;

  String _currentFolder = '';
  @override
  String get currentAnalyzedFolder => _currentFolder;

  AdvancedStorageAnalyzer? _advancedStorageAnalyzer;
  @override
  AdvancedStorageAnalyzer? get advancedStorageAnalyzer =>
      _advancedStorageAnalyzer;

  StorageAnalyzerV4? _storageAnalyzerV4;
  @override
  StorageAnalyzerV4? get storageAnalyzerV4 => _storageAnalyzerV4;

  //? these data will be loaded from the sqlite after reopening the app or after running the analyzer
  List<LocalFolderInfo> _foldersInfo = [];
  @override
  List<LocalFolderInfo>? get foldersInfo => _foldersInfo;

  List<ExtensionInfo>? _allExtensionsInfo;
  @override
  List<ExtensionInfo>? get allExtensionInfo => _allExtensionsInfo;

  @override
  AnalyzerReportInfoModel? reportInfo;

  //? last date the user performed (analyzing storage)
  @override
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
  @override
  Future<void> loadInitialAppData(RecentProvider recentProvider) async {
    await _loadLastAnalyzingDate();
    await _getReportInfo();
    await _getSavedExtensionsInfo();
    calcSections(_allExtensionsInfo, (sec) {
      recentProvider.setSections(sec);
    }, this);
  }

  //? get dir info by path
  @override
  Future<LocalFolderInfo?> getDirInfoByPath(String path) async {
    try {
      LocalFolderInfo localFolderInfo =
          _foldersInfo.firstWhere((element) => element.path == path);
      return localFolderInfo;
    } catch (e) {
      try {
        //* load its data form db if it doesn't exist in the local state
        var data = await DBHelper.getDataWhere(
          localFolderInfoTableName,
          pathString,
          path,
        );
        LocalFolderInfo localFolderInfo = LocalFolderInfo.fromJSON(data.first);
        _foldersInfo.add(localFolderInfo);
        return localFolderInfo;
      } catch (e) {
        return null;
      }
    }
  }

  //? to clear all saved data from the RAM
  @override
  void clearAllData() {
    _currentFolder = '';
    _advancedStorageAnalyzer = null;
    _storageAnalyzerV4 = null;
    notifyListeners();
  }

  //? to start analyzing storage
  @override
  Future<void> handleAnalyzeEvent(RecentProvider recentProvider) async {
    // _loading = true;
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    _loading = true;
    _currentFolder = 'Starting...';
    notifyListeners();
    Isolate isolate = await Isolate.spawn(runAnalyzeStorageIsolate, sendPort);
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
          _loading = false;
          //? if we reached here this mean the storage analyzer report done successfully
          await DBHelper.clearDb(tempDbName);
          await _saveReportInfo();
          calcSections(_allExtensionsInfo, (sec) {
            recentProvider.setSections(sec);
          }, this);
          await _setLastAnalyzingDate();
          await _handleSaveRecentFiles(recentProvider);
          await _saveResultsToSqlite();
          isolate.kill();
        } else if (message is int) {
          printOnDebug('Analyzing Time : ${message / 1000} Second');
        } else if (message is! SendPort) {
          //? here handle extensions
          // throw Exception(message);
        }
      },
    );
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
    for (var extension in storageAnalyzerV4!.allExtensionsInfo) {
      await DBHelper.insert(extensionInfoTableName, extension.toJSON());
    }
  }

  //? save folders sizes to sqlite
  Future<void> _saveFolderSizes() async {
    for (var folderInfo in storageAnalyzerV4!.allFolderInfoWithSize) {
      await DBHelper.insert(
        localFolderInfoTableName,
        folderInfo.toJSON(),
      );
    }
  }

  //? get saved extensions info
  Future<void> _getSavedExtensionsInfo() async {
    try {
      var data = await DBHelper.getData(extensionInfoTableName);
      List<ExtensionInfo> ei =
          data.map((e) => ExtensionInfo.fromJSON(e)).toList();
      _allExtensionsInfo = ei;
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
    await DBHelper.insert(
      analyzerReportInfoTableName,
      analyzerReportInfoModel.toJSON(),
    );
  }

  //? load report info
  Future<void> _getReportInfo() async {
    if (lastAnalyzingReportDate != null) {
      try {
        var data = await DBHelper.getData(analyzerReportInfoTableName);
        AnalyzerReportInfoModel analyzerReportInfoModel =
            AnalyzerReportInfoModel.fromJSON(data.first);
        reportInfo = analyzerReportInfoModel;
        notifyListeners();
      } catch (e) {
        printOnDebug('No report info yet');
      }
    }
  }

  //? get total storage size
  @override
  Future<int> getTotalDiskSpace() async {
    return ((await DiskSpace.getTotalDiskSpace ?? 0) * 1024 * 1024).toInt();
  }

  //? get free storage size
  @override
  Future<int> getFreeDiskSpace() async {
    return ((await DiskSpace.getFreeDiskSpace ?? 0) * 1024 * 1024).toInt();
  }

  //? get apps storage size
  @override
  Future<int> getAppsDiskSpace(int totalFilesSize) async {
    int total = await getTotalDiskSpace();
    int free = await getFreeDiskSpace();
    int files = totalFilesSize;
    return total - free - files;
  }
}
