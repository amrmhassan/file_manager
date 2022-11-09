// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/screens/analyzer_screen/isolates/analyzing_isolates.dart';
import 'package:explorer/screens/scanning_storage_screen/widgets/analyze_entity_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class ScanningStorageScreen extends StatefulWidget {
  static const String routeName = '/ScanningStorageScreen';
  const ScanningStorageScreen({super.key});

  @override
  State<ScanningStorageScreen> createState() => _ScanningStorageScreenState();
}

class _ScanningStorageScreenState extends State<ScanningStorageScreen> {
  AdvancedStorageAnalyzer? advancedStorageAnalyzer;
  FolderTreeV2? totalFolderTree;
  String currentFolder = '';
  bool loading = false;
  int timeTaken = 0;

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Time Taken: ${timeTaken / 1000}',
                style: h4TextStyleInactive,
              ),
              if (totalFolderTree != null)
                TextButton(
                    onPressed: () {
                      var f = totalFolderTree;
                      printOnDebug(f);
                    },
                    child: Text('Show FolderTree')),
              TextButton(
                onPressed: handleAnalyzeEvent,
                child: Text('Analyze Storage'),
              ),
              if (advancedStorageAnalyzer != null)
                AnalyzeEntityItem(
                  fileSystemEntity: advancedStorageAnalyzer!.filesInfo.first,
                  parentSize: 100,
                ),
              if (loading)
                Column(
                  children: [
                    Text(
                      currentFolder,
                      style: h4TextStyleInactive,
                    ),
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ],
                ),
            ],
          ),
        ));
  }

  void handleAnalyzeEvent() async {
    ReceivePort receivePort = ReceivePort();
    SendPort sendPort = receivePort.sendPort;
    setState(() {
      loading = true;
    });
    DateTime beforeStartAnalyzig = DateTime.now();
    Isolate.spawn(runAnalyzeStorageIsolate, sendPort);
    receivePort.listen(
      (message) {
        if (message is AdvancedStorageAnalyzer) {
          DateTime afterStartAnalyzing = DateTime.now();
          int analyzeTime = afterStartAnalyzing
              .difference(beforeStartAnalyzig)
              .inMilliseconds;
          setState(() {
            timeTaken += analyzeTime;
          });
          printOnDebug('Time Taken for analyze: ${analyzeTime / 1000}');
          //* here is the data of the finished results
          setState(() {
            loading = false;
            currentFolder = '';
            advancedStorageAnalyzer = message;
          });
        } else if (message is LocalFolderInfo) {
          //* here run the code with finishing a folder
          setState(() {
            currentFolder = path_operations.basename(message.path);
          });
        } else if (message is FolderTreeV2) {
          setState(() {
            totalFolderTree = message;
          });
        } else if (message is int) {
          setState(() {
            timeTaken += message;
          });
          printOnDebug('Time Taken for parse: ${message / 1000}');
        }
      },
    );
  }
}
