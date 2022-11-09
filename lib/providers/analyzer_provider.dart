import 'dart:isolate';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:path/path.dart' as path_operations;

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
import 'package:explorer/screens/analyzer_screen/isolates/analyzing_isolates.dart';
import 'package:flutter/cupertino.dart';

class AnalyzerProvider extends ChangeNotifier {
  bool _loading = false;
  get loading => _loading;

  String _currentFolder = '';
  get currentFolder => _currentFolder;

  AdvancedStorageAnalyzer? _advancedStorageAnalyzer;
  get advancedStorageAnalyzer => _advancedStorageAnalyzer;

  FolderTreeV2? _totalFolderTree;
  FolderTreeV2? get totalFolderTree => _totalFolderTree;

  void clearAllData() {
    _currentFolder = '';
    _advancedStorageAnalyzer = null;
    _totalFolderTree = null;
    notifyListeners();
  }

  void handleAnalyzeEvent() async {
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    _loading = true;
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
        } else if (message is FolderTreeV2) {
          _totalFolderTree = message;
          _currentFolder = '';
          _loading = false;
          notifyListeners();
        } else if (message is int) {
          printOnDebug('Time Taken: ${message / 1000} Second');
        } else if (message is! SendPort) {
          //? here handle exeptions
          // throw Exception(message);
        }
      },
    );
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
