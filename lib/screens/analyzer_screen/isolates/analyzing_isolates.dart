import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v2.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree_v2.dart';
import 'package:explorer/utils/general_utils.dart';

String parentPath = 'sdcard';
void runAnalyzeStorageIsolate(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  var obj = AdvancedStorageAnalyzer(parentPath);
  obj.startAnalyzing(
    onAllDone: () {
      sendPort.send(obj);
      int parseTime = getExecutionTime(() {
        StorageAnalyserV2 storageAnalyserV2 = StorageAnalyserV2(
          parentPath,
          obj.allEntitiesInfos,
          obj.filesInfo,
        );
        FolderTreeV2 folderTreeV2 = storageAnalyserV2.getFolderTreeV2();
        sendPort.send(folderTreeV2);
      });
      sendPort.send(parseTime);
    },
    onFolderDone: ((localFolderInfo) {
      sendPort.send(localFolderInfo);
    }),
    onError: (e, dir) {},
  );
}
