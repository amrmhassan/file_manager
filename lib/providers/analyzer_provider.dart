import 'dart:isolate';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v3.dart';
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
  bool _loading = false;
  get loading => _loading;

  bool _savingInfoToSqlite = false;
  bool get savingInfoToSqlite => _savingInfoToSqlite;

  String _currentFolder = '';
  get currentFolder => _currentFolder;

  AdvancedStorageAnalyzer? _advancedStorageAnalyzer;
  get advancedStorageAnalyzer => _advancedStorageAnalyzer;

  StorageAnalyserV3? _storageAnalyserV3;
  StorageAnalyserV3? get storageAnalyserV3 => _storageAnalyserV3;

  List<LocalFolderInfo>? _foldersInfo;
  List<LocalFolderInfo>? get foldersInfo => _foldersInfo;

//? to clear all saved data
  void clearAllData() {
    _currentFolder = '';
    _advancedStorageAnalyzer = null;
    _storageAnalyserV3 = null;
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
      (message) {
        if (message is AdvancedStorageAnalyzer) {
          //* here is the data of the finished results
          _currentFolder = 'Analyzing Data...';
          _advancedStorageAnalyzer = message;
          notifyListeners();
        } else if (message is LocalFolderInfo) {
          //* here run the code with finishing a folder
          _currentFolder = path_operations.basename(message.path);
          notifyListeners();
        } else if (message is StorageAnalyserV3) {
          //* here getting the folders info with sizes
          _storageAnalyserV3 = message;
          _currentFolder = '';
          _loading = false;
          saveFolderSizes();
        } else if (message is int) {
          printOnDebug('Time Taken: ${message / 1000} Second');
        } else if (message is! SendPort) {
          //? here handle exeptions
          // throw Exception(message);
        }
      },
    );
  }

  //? save the report info
  Future<void> _saveReportInfo() async {
    AnalyzerReportInfoModel analyzerReportInfoModel = AnalyzerReportInfoModel(
      dateDone: DateTime.now(),
      folderCount: _storageAnalyserV3!.allFolderInfoWithSize.length,
      filesCount: _storageAnalyserV3!.allFilesInfo.length,
      extensionsCount: 0,
      totalFilesSize: _advancedStorageAnalyzer!.allFilesSize,
    );
    await DBHelper.insert(
        analyzerReportInfoTableName, analyzerReportInfoModel.toJSON());
  }

//? get saved folders info
  Future<void> getSavedFoldersInfo() async {
    var data = await DBHelper.getData(localFolderInfoTableName);
    List<LocalFolderInfo> fi =
        data.map((e) => LocalFolderInfo.fromJSON(e)).toList();
    _foldersInfo = fi;
    notifyListeners();
  }

  //? save folders sizes to sqlite
  Future<void> saveFolderSizes() async {
    _savingInfoToSqlite = true;
    notifyListeners();
    for (var folderInfo in storageAnalyserV3!.allFolderInfoWithSize) {
      await DBHelper.insert(localFolderInfoTableName, folderInfo.toJSON());
    }
    _saveReportInfo();
    _savingInfoToSqlite = false;
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
}
