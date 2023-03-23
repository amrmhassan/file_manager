import 'dart:isolate';

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyzer_v4.dart';
import 'package:explorer/utils/general_utils.dart';

//? to start analyzing the storage
void runAnalyzeStorageIsolate(Map<String, dynamic> data) async {
  SendPort sendPort = data['sendPort'];
  String parentPath = data['parentPath'];

  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  DateTime beforeScanning = DateTime.now();

  // var splitter = StorageAnalyzerSplitter(parentPath, sendPort);
  // var res = await splitter.run();
  // DateTime after = DateTime.now();
  // sendPort.send(after.difference(beforeScanning).inMilliseconds);
  // sendPort.send(res);
  // logger.i('Analyzing Done');
  // return;

  var obj = AdvancedStorageAnalyzer(parentPath);
  obj.startAnalyzing(
    onAllDone: () {
      DateTime afterScanning = DateTime.now();
      sendPort.send(afterScanning.difference(beforeScanning).inMilliseconds);
      sendPort.send(obj);
      int parseTime = getExecutionTime(() {
        StorageAnalyzerV4 storageAnalyzerV4 = StorageAnalyzerV4(
          allFilesInfo: obj.filesInfo,
          allFoldersInfo: obj.foldersInfo,
          parentPath: parentPath,
        );
        storageAnalyzerV4.run();

        sendPort.send(storageAnalyzerV4);
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
