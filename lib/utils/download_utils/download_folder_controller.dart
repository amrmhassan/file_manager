// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

//?

class DownloadFolderController extends DownloadTaskController {
  late Iterable<ShareSpaceItemModel> folders;
  late Iterable<ShareSpaceItemModel> files;
  late int size;
  final int initialCount;

  late int count;

  final Function(int size) setTaskSize;
  DownloadTaskController? currentDownloadingFile;
  bool folderDownloadCancelled = false;

  DownloadFolderController({
    required super.downloadPath,
    required super.myDeviceID,
    required super.mySessionID,
    required super.remoteFilePath,
    required super.url,
    required super.setProgress,
    required super.setSpeed,
    required super.remoteDeviceID,
    required super.remoteDeviceName,
    required super.maximumParallelDownloadThreads,
    required super.downloadAlgorithm,
    required this.setTaskSize,
    required this.initialCount,
  }) {
    count = initialCount;
  }

  Future setInitialCount() async {}

  Future createDownloadFolders() async {
    Directory mainDir = Directory(downloadPath);
    if (!await mainDir.exists()) {
      await mainDir.create();
    }

    for (var folder in folders) {
      Directory dir =
          Directory(folder.path.replaceFirst(remoteFilePath, downloadPath));
      if (!await dir.exists()) {
        await dir.create();
      }
    }
  }

  Future getEntitiesPaths() async {
    late BuildContext modalContext;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: navigatorKey.currentContext!,
      builder: (context) {
        modalContext = context;
        return ModalWrapper(
            showTopLine: false,
            color: kCardBackgroundColor,
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: kMainIconColor,
                  strokeWidth: 2,
                ),
                VSpace(),
                Text('loading-info'.i18n()),
              ],
            ));
      },
    );

    var res = await Dio().get(
      url,
      options: Options(
        headers: {
          KHeaders.folderPathHeaderKey: Uri.encodeComponent(remoteFilePath),
          KHeaders.sessionIDHeaderKey: mySessionID,
        },
      ),
    );
    var data = res.data as List;
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    try {
      Navigator.pop(modalContext);
    } catch (e) {
      logger.e(e);
      await Future.delayed(Duration(milliseconds: 500));
      try {
        Navigator.pop(modalContext);
      } catch (e) {
        logger.e(e);
      }
    }
    folders = items.where((element) => element.entityType == EntityType.folder);
    files = items.where((element) => element.entityType == EntityType.file);
    size = items.fold(
        0, (previousValue, element) => previousValue + (element.size ?? 0));
    setTaskSize(size);
  }

  Future downloadFiles() async {
    for (var file in files) {
      String localFilePath =
          file.path.replaceFirst(remoteFilePath, downloadPath);
      String downloadURL = url.replaceAll(
          EndPoints.getFullFolderContent, EndPoints.downloadFile);

      currentDownloadingFile = DownloadTaskController(
        downloadAlgorithm: downloadAlgorithm,
        maximumParallelDownloadThreads: maximumParallelDownloadThreads,
        downloadPath: localFilePath,
        myDeviceID: myDeviceID,
        mySessionID: mySessionID,
        remoteFilePath: file.path,
        url: downloadURL,
        setProgress: (p) {},
        setSpeed: setSpeed,
        remoteDeviceID: remoteDeviceID,
        remoteDeviceName: remoteDeviceName,
        onReceived: (chunkSize) {
          count += chunkSize;
          setProgress(count);
        },
      );
      await currentDownloadingFile?.downloadFile(false);
      if (folderDownloadCancelled) break;
    }
  }

  @override
  void cancelTask() {
    try {
      currentDownloadingFile?.cancelTask();
      folderDownloadCancelled = true;
    } catch (e) {
      logger.i('Download Cancelled', null, StackTrace.current);
    }
  }

  @override
  Future downloadFile([bool ask = true]) async {
    await getEntitiesPaths();
    await createDownloadFolders();
    // i returned this value not to notify the download provider that the download is paused
    if (size == 0) return Future.value(10);

    await downloadFiles();
    if (folderDownloadCancelled) {
      return Future.value(0);
    } else {
      return Future.value(size);
    }
  }
}
