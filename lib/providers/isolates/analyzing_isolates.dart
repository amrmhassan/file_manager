import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v4.dart';
import 'package:explorer/utils/general_utils.dart';

String parentPath = 'sdcard';
void runAnalyzeStorageIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  var obj = AdvancedStorageAnalyzer(parentPath);
  DateTime beforeScanning = DateTime.now();
  obj.startAnalyzing(
    onAllDone: () {
      DateTime afterScanning = DateTime.now();
      sendPort.send(afterScanning.difference(beforeScanning).inMilliseconds);
      sendPort.send(obj);
      int parseTime = getExecutionTime(() {
        StorageAnalyserV4 storageAnalyserV4 = StorageAnalyserV4(
          allFilesInfo: obj.filesInfo,
          allFoldersInfo: obj.foldersInfo,
          children: obj.allEntitiesPathes,
          parentPath: parentPath,
        );
        storageAnalyserV4.run();

        sendPort.send(storageAnalyserV4);
      });
      sendPort.send(parseTime);
    },
    onFolderDone: ((localFolderInfo) {
      sendPort.send(localFolderInfo);
    }),
    onError: (e, dir) {
      sendPort.send(e);
    },
  );
}
