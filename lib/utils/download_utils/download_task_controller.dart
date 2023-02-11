// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/utils/download_utils/custom_dio.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;
import 'package:uuid/uuid.dart';

class ChunkProgressModel {
  final int size;
  int count;
  final String filePath;

  ChunkProgressModel({
    required this.size,
    required this.count,
    required this.filePath,
  });
}

//# when the group host i should close the connection at all

//# to resume the download you should first read the paths to files from the temp dir of the task
//# reconstruct the temp dir from the download controller class by calling the function of temp dir
//# when starting the download check if the temp dir of that task exists or not
//# if not just start downloading from the start
//# if exist read the files inside it and see what is the end for each chunk and make the client side to determine the start and the end to download for each chunk
//# you won't need any adjustments on the server side because the server already handles the chunks principle
//# you just need to set the start of the chunk download from the next byte in the saved file and the to the end of the chunk
//# e.g the full chunk size is 10 byte => you downloaded 6 bytes => and the chunk arrangement is from 1000 to 1010
//# in the next check your new start will be 1006 to 1010 and you will get a request from the server with the remaining bytes
//# append these bytes to the file and you are done
//# DONE -  you will just need to save each chunk full size in a file in the same temp dir (make it text file or any thing you want, or use hive)
//# next you need to read to set the

//! the error now is that dio deletes the previous downloaded chunk when resuming the download
//! so i will create my own download logic

class DownloadTaskController {
  //
  final CustomCancelToken _customCancelToken = CustomCancelToken();
  final int chunkSize = 1024 * 1024 * 8;
  int get chunksNumber => (length / chunkSize).ceil();
  bool continuingDownload = false;
  // temp dir info
  late Directory tempDir;
  late String tempDirPath;

  // sub files info
  List<Future> futures = <Future>[];
  late List<List<Future<dynamic>>> listOfDownloads;
  List<ChunkProgressModel> chunksInfo = [];
  int previousReceived = 0;

  // task runtime properties
  int received = 0;
  late int length;
  late String fileName;

  // outside props
  final int maximumParallelDownloadThreads;
  String downloadPath;
  final String remoteFilePath;
  final String mySessionID;
  final String myDeviceID;
  final String url;
  final Function(int p) setProgress;
  final Function(double speed) setSpeed;
  final String remoteDeviceName;
  final String remoteDeviceID;

  DownloadTaskController({
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

  // void _resetRunTimeVariables() {
  //   chunksInfo.clear();
  //   futures.clear();
  //   received = initialReceived;
  //   customDio = CustomDio();
  //   _customCancelToken = CustomCancelToken();
  // }

  void _reconstructChunkSizes() {
    String infoFilePath = '$tempDirPath/info_file.txt';
    File file = File(infoFilePath);
    bool exist = file.existsSync();
    if (!exist) return;
    continuingDownload = true;
    // _resetRunTimeVariables();

    // {
    //    'path':'the path to sub file'
    //    'size': the supposed sub file size
    // }

    // or
    // [path, size]
    // so 0=> path
    //    1=> size

    // to read the saved info from the text file
    List<List<dynamic>> retrievedChunksSizes =
        (file.readAsStringSync().split('||')..removeLast())
            .map((e) => e.split('|'))
            .toList();
    for (var chunkInfo in retrievedChunksSizes) {
      try {
        int count = File(chunkInfo[0]).lengthSync();
        chunksInfo.add(
          ChunkProgressModel(
            size: int.parse(chunkInfo[1]),
            count: count,
            filePath: chunkInfo[0],
          ),
        );
      } catch (e) {
        // if error happened this means that the file has been deleted and data should be deleted first
        //! if the file doesn't exist i need to make sure by deleting the temp dir for this file because the info file may be deleted but the sub files exist and this will make a problem
        chunksInfo.add(
          ChunkProgressModel(
            size: int.parse(chunkInfo[1]),
            count: 0,
            filePath: chunkInfo[0],
          ),
        );
      }
    }
    previousReceived = chunksInfo.fold(
      0,
      (previousValue, element) => previousValue + element.count,
    );
  }

  void _createChunksInfoFile() {
    // this won't be needed in case of continuing stopped downloading
    // if the info file already exists, this means that you need to read the data from it and set the global variable "continuingDownload" to be true
    // in the downloading process you need to update your code to start not from zero but from the count of the chunkInfo Model and end at the chunkInfo model size
    String infoFilePath = '$tempDirPath/info_file.txt';
    File file = File(infoFilePath);
    bool exist = file.existsSync();
    if (exist) return;

    RandomAccessFile infoFile =
        File(infoFilePath).openSync(mode: FileMode.append);
    for (var chunk in chunksInfo) {
      infoFile.writeStringSync('${chunk.filePath}|${chunk.size}||');
    }
    infoFile.closeSync();
  }

  void cancelTask() {
    try {
      _customCancelToken.cancel();
    } catch (e) {
      logger.i('Download Cancelled', null, StackTrace.current);
    }
  }

  void _updateChunkProgress(String chunkPath, int newChunkSize) {
    int index =
        chunksInfo.indexWhere((element) => element.filePath == chunkPath);
    ChunkProgressModel chunkProgressModel = chunksInfo[index];
    chunkProgressModel.count += newChunkSize;
    chunksInfo[index] = chunkProgressModel;
  }

  Future<bool> _fileAlreadyDownloadedChecker() async {
    // this function will block the download process if it was returned true
    bool exist = File(downloadPath).existsSync();

    // overwrite or rename can be true not both
    bool overwrite = false;
    bool rename = false;
    if (exist) {
      await showModalBottomSheet(
        context: navigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        builder: (context) => DoubleButtonsModal(
          onOk: () {
            overwrite = true;
          },
          onCancel: () {
            rename = true;
          },
          okColor: kBlueColor,
          okText: 'Overwrite',
          cancelText: 'Rename ',
          title: 'File already download',
          subTitle: 'Overwrite the downloaded file Or rename the new one ?',
        ),
      );
    }

    // if overwrite then return false to continue download and overwrite the existing file
    if (overwrite) return false;
    // if rename, rename the downloaded file local path then continue download
    if (rename) {
      // here i will use the rename
      String fileName = getFileName(downloadPath);
      String fileExtension = getFileExtension(downloadPath);
      String dirName = path_operations.dirname(downloadPath);
      String newPath =
          '$dirName/$fileName-${Uuid().v4().substring(0, 8)}.$fileExtension';
      downloadPath = newPath;

      return false;
    }

    return exist;
  }

  Future<void> _initFileInfo() async {
    // initializing file length
    length = int.parse((await Dio().get(
      url,
      options: Options(
        headers: {
          reqIntentPathHeaderKey: 'length',
          filePathHeaderKey: Uri.encodeComponent(remoteFilePath),
        },
      ),
    ))
        .data);
    fileName = path_operations.basename(remoteFilePath);
  }

  void _initTempDir() {
    // getting the chunks number for the final file
    // making the temp dir for that will hold the temp files
    tempDir =
        Directory('${path_operations.dirname(downloadPath)}/.$fileName-tmp');
    if (!tempDir.existsSync()) {
      tempDir.createSync();
    }
    tempDirPath = tempDir.path;
  }

  void _addDownloadFuturesAndSetChunksInfo() {
    // [] contains each chunk , | means that i downloaded till this byte
    // [12|34][5|678][345|6][2345|]
    // when i ==0 => i am pointing to the first  chunk then the start should be from the downloaded part ==> count+(i*chunkSize) = 2+(0*4) =2 ,, end = (i+1)*chunkSize = 4
    // when i ==1 => i am pointing to the second chunk then the start should be from the downloaded part ==> count+(i*chunkSize) = 1+(1*4) =5 ,, end = (i+1)*chunkSize = 8
    int loopEnd = continuingDownload ? chunksInfo.length : chunksNumber;
    for (var i = 0; i < loopEnd; i++) {
      late int start;
      if (continuingDownload) {
        start = chunksInfo[i].count + i * chunkSize;
      } else {
        start = i * chunkSize;
      }
      int end = (i + 1) * chunkSize;
      if (end >= length) {
        end = length;
      }
      String range = 'bytes=$start-$end';
      if (!continuingDownload) {
        chunksInfo.add(ChunkProgressModel(
          size: end - start,
          count: 0,
          filePath: '$tempDirPath/$fileName-$i',
        ));
      }

      DateTime before = DateTime.now();
      // to merge the headers, user headers and this function headers
      Map<String, dynamic> mergedHeaders = {
        HttpHeaders.rangeHeader: range,
        filePathHeaderKey: Uri.encodeComponent(remoteFilePath),
        sessionIDHeaderKey: mySessionID,
        deviceIDString: myDeviceID,
        "Accept": "application/octet-stream",
      };
      CustomDio customDio = CustomDio();
      customDio.timeOutMilliSecond = 5000;

      futures.add(
        customDio.download(
          url,
          chunksInfo[i].filePath,
          cancelToken: _customCancelToken,
          onReceiveProgress: (_, total, chunkSize) {
            _updateChunkProgress(chunksInfo[i].filePath, chunkSize);
            received = chunksInfo.fold(
              0,
              (previousValue, element) => previousValue + element.count,
            );

            setProgress(received);
            DateTime after = DateTime.now();
            int diff = after.difference(before).inMilliseconds;
            //! i subtracted the initialReceived to avoid miss speed measuring=> never tested yet
            double speed =
                ((received - previousReceived) / 1024 / 1024) / (diff / 1000);

            setSpeed(speed);
          },
          headers: mergedHeaders,

          // options: Options(
          //   responseType: ResponseType.stream,
          // ),
        ),
      );
    }
  }

  void _handleSplitFileTask() {
    // this function will return set the variable continuingDownload to be true if it finds the info file
    // this means that the chunks list has been constructed and i don't want to construct it from the start
    // so if continuingDownload==true => then i need to use the reconstructed version of the info list to continue downloading

    listOfDownloads = List.generate(
      (futures.length / maximumParallelDownloadThreads).ceil(),
      (index) => futures.sublist(
          index * maximumParallelDownloadThreads,
          ((index + 1) * maximumParallelDownloadThreads) >= futures.length
              ? futures.length
              : ((index + 1) * maximumParallelDownloadThreads)),
    );
  }

  Future<void> _downloadChunks() async {
    for (var downloadPatch in listOfDownloads) {
      await Future.wait(downloadPatch);
    }
  }

  Future<void> _collectTheFinalFile() async {
    var finalFile = await File(downloadPath).open(mode: FileMode.append);
    // collecting the final file from sub files
    for (var chunk in chunksInfo) {
      File subFile = File(chunk.filePath);
      await finalFile.writeFrom(subFile.readAsBytesSync());
    }
    // deleting temp files
    finalFile.closeSync();
  }

  Future<void> _deleteTempDir() async {
    await tempDir.delete(recursive: true);
  }

  //? to download a file as chunks each chunk is at most equals the chunkSize
  Future<dynamic> downloadFile() async {
    try {
      //? this function will support continue corrupted downloads later by downloading the stopped chunks
      if (await _fileAlreadyDownloadedChecker()) {
        return;
      }
      await _initFileInfo();
      _initTempDir();
      _reconstructChunkSizes();
      _addDownloadFuturesAndSetChunksInfo();
      _createChunksInfoFile();
      _handleSplitFileTask();
      try {
        await _downloadChunks();
        logger.e('received $received length $length');

        if ((received) != length) {
          // zero return mean that the  isn't finished, paused
          return 0;
        }
      } catch (e) {
        // null return means download error
        return null;
      }

      await _collectTheFinalFile();
      await _deleteTempDir();
      // length return means download finished
      return length;
    } catch (e, s) {
      throw CustomException(
        e: e,
        s: s,
        rethrowError: true,
      );
    }
  }
}

// first
// received 9956548
// initial  0

// second
// received
