import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:path/path.dart' as path_operations;

bool fileAlreadyDownloadedChecker(String filePath) {
  return File(filePath).existsSync();
}

int maximumParallelDownloadThreads = 20;

//? to download a file as chunks
Future<int?> chunkedDownloadFile({
  required String url,
  required String downloadPath,
  required Function(int p) setProgress,
  Function(double speed)? setSpeed,
  required Map<String, dynamic> headers,
  bool onlyLength = false,
}) async {
  try {
    //? this function will support continue corrupted downloads later by downloading the stopped chunks
    // initializing chunk size to be 8MB per request

    if (fileAlreadyDownloadedChecker(downloadPath)) {
      print('File already downloaded');
      return File(downloadPath).lengthSync();
    }

    Dio dio = Dio();
    // dio.options.connectTimeout = 5000; //5s
    const chunkSize = 1024 * 1024 * 8;
    // const chunkSize = 3;
    // getting file info from the server endpoints
    int length = int.parse((await dio.get(
      '$url/length',
      options: Options(
        headers: {
          reqIntentPathHeaderKey: 'length',
          filePathHeaderKey: headers[filePathHeaderKey],
        },
      ),
    ))
        .data);
    if (onlyLength) return length;
    int received = 0;
    String fileName = path_operations
        .basename(Uri.decodeComponent(headers[filePathHeaderKey]));
    // getting the chunks number for the final file
    int chunksNumber = (length / chunkSize).ceil();
    // making the temp dir for that will hold the temp files
    Directory tempDir =
        Directory('${path_operations.dirname(downloadPath)}/.tmp');
    if (!tempDir.existsSync()) tempDir.createSync();
    String tempDirPath = tempDir.path;

    // splitting the final file into sub requests and mark them for download
    var futures = <Future>[];
    List<String> files = [];
    List<int> progressList = List.generate(chunksNumber, (index) => 0);
    for (var i = 0; i < chunksNumber; i++) {
      var start = i * chunkSize;
      var end = (i + 1) * chunkSize;
      if (end >= length) {
        end = length;
      }
      var range = 'bytes=$start-$end';
      files.add('$tempDirPath/$fileName-$i');

      DateTime before = DateTime.now();
      // to merge the headers, user headers and this function headers
      Map<String, dynamic> mergedHeaders = <String, dynamic>{};
      mergedHeaders.addAll({
        HttpHeaders.rangeHeader: range,
      });
      mergedHeaders.addAll(headers);

      futures.add(
        dio.download(
          url,
          files[i],
          onReceiveProgress: (count, total) {
            progressList[i] = count;
            received = progressList.fold(
                0, (previousValue, element) => previousValue + element);
            setProgress(received);
            if (setSpeed != null) {
              DateTime after = DateTime.now();
              int diff = after.difference(before).inMilliseconds;
              double speed = (received / 1024 / 1024) / (diff / 1000);
              setSpeed(speed);
            }
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
    for (var downloadPatch in listOfDownloads) {
      await Future.wait(downloadPatch);
    }
    var finalFile = await File(downloadPath).open(mode: FileMode.append);
    // collecting the final file from sub files
    for (var subFilePath in files) {
      File subFile = File(subFilePath);
      await finalFile.writeFrom(subFile.readAsBytesSync());
    }
    // deleting temp files
    finalFile.closeSync();
    tempDir.deleteSync(recursive: true);
    return length;
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
  return null;
}
