import 'dart:isolate';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v4.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:path/path.dart' as path_operations;

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/screens/analyzer_screen/isolates/analyzing_isolates.dart';
import 'package:flutter/cupertino.dart';

class AnalyzerProvider extends ChangeNotifier {
  //? these data will be available after running the analyzer without closing the app
  bool _loading = false;
  get loading => _loading;

  bool _savingInfoToSqlite = false;
  bool get savingInfoToSqlite => _savingInfoToSqlite;

  String _currentFolder = '';
  get currentFolder => _currentFolder;

  AdvancedStorageAnalyzer? _advancedStorageAnalyzer;
  get advancedStorageAnalyzer => _advancedStorageAnalyzer;

  StorageAnalyserV4? _storageAnalyserV4;
  StorageAnalyserV4? get storageAnalyserV4 => _storageAnalyserV4;

  //? these data will be loaded from the sqlite after reopening the app or after running the analyzer
  List<LocalFolderInfo>? _foldersInfo;
  List<LocalFolderInfo>? get foldersInfo => _foldersInfo;

  List<ExtensionInfo>? _allExtensionsInfo;
  List<ExtensionInfo>? get allExtensionInfo => _allExtensionsInfo;

//? to clear all saved data
  void clearAllData() {
    _currentFolder = '';
    _advancedStorageAnalyzer = null;
    _storageAnalyserV4 = null;
    notifyListeners();
  }

//? to start anayzing storage
  Future<void> handleAnalyzeEvent() async {
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    _loading = true;
    _currentFolder = 'Starting...';
    notifyListeners();
    Isolate.spawn(runAnalyzeStorageIsolate, sendPort);
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
        } else if (message is StorageAnalyserV4) {
          //* here getting the folders info with sizes
          _storageAnalyserV4 = message;
          _currentFolder = '';
          _foldersInfo = message.allFolderInfoWithSize;
          _allExtensionsInfo = message.allExtensionsInfo;
          _loading = false;
          await saveResultsToSqlite();
        } else if (message is int) {
          printOnDebug('Time Taken: ${message / 1000} Second');
        } else if (message is! SendPort) {
          //? here handle exeptions
          // throw Exception(message);
        }
      },
    );
  }

//? save data to sqlite
  Future<void> saveResultsToSqlite() async {
    _savingInfoToSqlite = true;
    notifyListeners();
    await _saveExtensionsInfo();
    await _saveFolderSizes();
    _savingInfoToSqlite = false;
    notifyListeners();
  }

  //? save extensions info to sqlite
  Future<void> _saveExtensionsInfo() async {
    for (var extension in storageAnalyserV4!.allExtensionsInfo) {
      await DBHelper.insert(extensionInfoTableName, extension.toJSON());
    }
  }

  //? save folders sizes to sqlite
  Future<void> _saveFolderSizes() async {
    for (var folderInfo in storageAnalyserV4!.allFolderInfoWithSize) {
      await DBHelper.insert(localFolderInfoTableName, folderInfo.toJSON());
    }
    _saveReportInfo();
  }

//? get saved folders info
  Future<void> getSavedFoldersInfo() async {
    var data = await DBHelper.getData(localFolderInfoTableName);
    List<LocalFolderInfo> fi =
        data.map((e) => LocalFolderInfo.fromJSON(e)).toList();
    _foldersInfo = fi;
    notifyListeners();
  }

  //? get saved extensions info
  Future<void> getSavedExtensionsInfo() async {
    var data = await DBHelper.getData(extensionInfoTableName);
    List<ExtensionInfo> ei =
        data.map((e) => ExtensionInfo.fromJSON(e)).toList();
    _allExtensionsInfo = ei;
    notifyListeners();
  }

  //? get extension files
  List<LocalFileInfo> getExtensionFiles(String ext) {
    var extFiles = _advancedStorageAnalyzer!.filesInfo
        .where((element) => getFileExtension(element.path) == ext)
        .toList();
    extFiles.sort(
      (a, b) => b.size.compareTo(a.size),
    );
    return extFiles;
  }

  //? save the report info
  Future<void> _saveReportInfo() async {
    AnalyzerReportInfoModel analyzerReportInfoModel = AnalyzerReportInfoModel(
      dateDone: DateTime.now(),
      folderCount: _storageAnalyserV4!.allFolderInfoWithSize.length,
      filesCount: _storageAnalyserV4!.allFilesInfo.length,
      extensionsCount: 0,
      totalFilesSize: _advancedStorageAnalyzer!.allFilesSize,
    );
    await DBHelper.insert(
        analyzerReportInfoTableName, analyzerReportInfoModel.toJSON());
  }
}
