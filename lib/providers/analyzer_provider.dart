import 'dart:isolate';
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
  get totalFolderTree => _totalFolderTree;

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
        }
      },
    );
  }
}
