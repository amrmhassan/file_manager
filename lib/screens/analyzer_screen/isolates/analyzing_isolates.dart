import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v3.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
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
        // StorageAnalyserV3 storageAnalyserV2 = StorageAnalyserV3(
        //   parentPath,
        //   obj.allEntitiesInfos,
        //   obj.filesInfo,
        // );
        StorageAnalyserV3 storageAnalyserV2 = StorageAnalyserV3(
            allFilesInfo: obj.filesInfo,
            allFoldersInfo: obj.foldersInfo,
            children: obj.allEntitiesInfos,
            parentPath: parentPath);
        FolderTreeV2 folderTreeV2 = storageAnalyserV2.getFolderTreeV2();
        sendPort.send(folderTreeV2);
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
