import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:path/path.dart' as path_operations;

class TaskDownloadUtils {
  //
  final Dio dio = Dio();
  final int chunkSize = 1024 * 1024 * 8;
  int get chunksNumber => (length / chunkSize).ceil();

  // temp dir info
  late Directory tempDir;
  late String tempDirPath;

  // sub files info
  List<Future> futures = <Future>[];
  List<String> subFilesPaths = [];

  // task runtime properties
  int received = 0;
  late int length;
  late String fileName;

  // outside props
  final int maximumParallelDownloadThreads;
  final String downloadPath;
  final String remoteFilePath;
  final String mySessionID;
  final String myDeviceID;
  final String url;
  final Function(int p) setProgress;
  final Function(double speed) setSpeed;
  final String remoteDeviceName;
  final String remoteDeviceID;

  TaskDownloadUtils({
    required this.downloadPath,
    required this.myDeviceID,
    required this.mySessionID,
    required this.remoteFilePath,
    required this.url,
    required this.setProgress,
    required this.setSpeed,
    required this.remoteDeviceID,
    required this.remoteDeviceName,
    this.maximumParallelDownloadThreads = 20,
  });

  bool _fileAlreadyDownloadedChecker(String filePath) {
    return File(filePath).existsSync();
  }

  Future<void> _initFileInfo() async {
    // initializing file length

    length = int.parse((await dio.get(
      '$url/length',
      options: Options(
        headers: {
          reqIntentPathHeaderKey: 'length',
          filePathHeaderKey: Uri.decodeComponent(remoteFilePath),
        },
      ),
    ))
        .data);
    fileName = path_operations
        .basename(Uri.decodeComponent(Uri.decodeComponent(remoteFilePath)));
  }

  Future<void> _initTempDir() async {
    // getting the chunks number for the final file
    // making the temp dir for that will hold the temp files
    tempDir =
        Directory('${path_operations.dirname(downloadPath)}/.$fileName-tmp');
    if (!tempDir.existsSync()) {
      await tempDir.create();
    }
    tempDirPath = tempDir.path;
  }

  List<List<Future>> _splitFileTask() {
    List<int> progressList = List.generate(chunksNumber, (index) => 0);
    for (var i = 0; i < chunksNumber; i++) {
      var start = i * chunkSize;
      var end = (i + 1) * chunkSize;
      if (end >= length) {
        end = length;
      }
      var range = 'bytes=$start-$end';
      subFilesPaths.add('$tempDirPath/$fileName-$i');

      DateTime before = DateTime.now();
      // to merge the headers, user headers and this function headers
      Map<String, dynamic> mergedHeaders = {
        HttpHeaders.rangeHeader: range,
        filePathHeaderKey: Uri.encodeComponent(remoteFilePath),
        sessionIDHeaderKey: mySessionID,
        deviceIDString: myDeviceID,
      };

      futures.add(
        dio.download(
          url,
          subFilesPaths[i],
          onReceiveProgress: (count, total) {
            progressList[i] = count;
            received = progressList.fold(
                0, (previousValue, element) => previousValue + element);
            setProgress(received);
            DateTime after = DateTime.now();
            int diff = after.difference(before).inMilliseconds;
            double speed = (received / 1024 / 1024) / (diff / 1000);
            setSpeed(speed);
          },
          options: Options(
            headers: mergedHeaders,
            responseType: ResponseType.stream,
          ),
        ),
      );
    }
    List<List<Future>> listOfDownloads = List.generate(
      (futures.length / maximumParallelDownloadThreads).ceil(),
      (index) => futures.sublist(
          index * maximumParallelDownloadThreads,
          ((index + 1) * maximumParallelDownloadThreads) >= futures.length
              ? futures.length
              : ((index + 1) * maximumParallelDownloadThreads)),
    );

    return listOfDownloads;
  }

  Future<void> _downloadChunks() async {
    var listOfDownloads = _splitFileTask();

    for (var downloadPatch in listOfDownloads) {
      await Future.wait(downloadPatch);
    }
  }

  Future<void> _collectTheFinalFile() async {
    var finalFile = await File(downloadPath).open(mode: FileMode.append);
    // collecting the final file from sub files
    for (var subFilePath in subFilesPaths) {
      File subFile = File(subFilePath);
      await finalFile.writeFrom(subFile.readAsBytesSync());
    }
    // deleting temp files
    finalFile.closeSync();
  }

  Future<void> _deleteTempDir() async {
    await tempDir.delete(recursive: true);
  }

  //? to download a file as chunks each chunk is at most equals the chunkSize
  Future<void> downloadFile() async {
    try {
      //? this function will support continue corrupted downloads later by downloading the stopped chunks
      if (_fileAlreadyDownloadedChecker(downloadPath)) {
        return;
      }
      await _initFileInfo();
      await _initTempDir();
      await _downloadChunks();
      await _collectTheFinalFile();
      await _deleteTempDir();
    } catch (e, s) {
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
  }
}
