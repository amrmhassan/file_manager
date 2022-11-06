// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/screens/scanning_storage_screen/widgets/analyze_entity_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

void runAnalyzeStorageIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  var obj = AdvancedStorageAnalyzer('sdcard/');
  obj.startAnalyzing(
    onAllDone: () {
      sendPort.send(obj);
    },
    onFolderDone: ((localFolderInfo) {
      sendPort.send(localFolderInfo);
    }),
    onError: (e, dir) {},
  );
  Future.delayed(Duration(seconds: 15)).then(
    (value) {
      printOnDebug(
          'All Folder count After Waiting 1 sec : ${obj.foldersInfo.length}');
    },
  );
}

class ScanningStorageScreen extends StatefulWidget {
  static const String routeName = '/ScanningStorageScreen';
  const ScanningStorageScreen({super.key});

  @override
  State<ScanningStorageScreen> createState() => _ScanningStorageScreenState();
}

class _ScanningStorageScreenState extends State<ScanningStorageScreen> {
  AdvancedStorageAnalyzer? advancedStorageAnalyzer;
  String currentFolder = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: handleAnalyzeEvent,
                child: Text('Analyze Storage'),
              ),
              if (advancedStorageAnalyzer != null)
                AnalyzeEntityItem(
                  fileSystemEntity: advancedStorageAnalyzer!.filesInfo.first,
                  onDirTapped: (path) {},
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
    Isolate.spawn(runAnalyzeStorageIsolate, sendPort);
    receivePort.listen(
      (message) {
        if (message is AdvancedStorageAnalyzer) {
          //* here is the data of the finished results
          setState(() {
            loading = false;
            currentFolder = '';
            advancedStorageAnalyzer = message;
          });
          printOnDebug('Folders Count: ${message.foldersInfo.length}');
          printOnDebug('All Files Sizes: ${message.allFilesSize.toMB}');
          var testPath = message.filesInfo
              .map(
                (e) => e.path,
              )
              .toList();
          printOnDebug('---------------------------------');
          printOnDebug('---------------------------------');
        } else if (message is LocalFolderInfo) {
          //* here run the code with finishing a folder
          setState(() {
            currentFolder = path_operations.basename(message.path);
          });
        }
      },
    );
  }
}
