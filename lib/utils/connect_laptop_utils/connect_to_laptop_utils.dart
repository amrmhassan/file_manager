// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/models/captures_entity_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';

Future<Map<String, int>> getPhoneStorageInfo(BuildContext context) async {
  var res = await Dio()
      .get(connectLaptopPF(context).getPhoneConnLink(EndPoints.getStorage));
  int freeSpace = int.parse(res.headers.value(KHeaders.freeSpaceHeaderKey)!);
  int totalSpace = int.parse(res.headers.value(KHeaders.totalSpaceHeaderKey)!);

  return {
    KHeaders.freeSpaceHeaderKey: freeSpace,
    KHeaders.totalSpaceHeaderKey: totalSpace,
  };
}

Future<void> getLaptopFolderContent({
  required String folderPath,
  required ShareItemsExplorerProvider shareItemsExplorerProvider,
  required ConnectLaptopProvider connectLaptopProvider,
  bool shareSpace = false,
}) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    String connLink = getConnLink(
        connectLaptopProvider.remoteIP!,
        connectLaptopProvider.remotePort!,
        shareSpace ? EndPoints.getShareSpace : EndPoints.getFolderContent);

    var res = await Dio().get(
      connLink,
      options: shareSpace
          ? null
          : Options(
              headers: {
                KHeaders.folderPathHeaderKey: Uri.encodeComponent(folderPath),
              },
            ),
    );
    var data = res.data as List;
    String? folderPathRetrieved;
    folderPathRetrieved = Uri.decodeComponent(
        res.headers.value(KHeaders.parentFolderPathHeaderKey) ?? '');
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    shareItemsExplorerProvider.updatePath(
        folderPathRetrieved.isEmpty ? null : folderPathRetrieved, items);

    shareItemsExplorerProvider.setLoadingItems(false, true);
  } catch (e, s) {
    shareItemsExplorerProvider.setLoadingItems(false);
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<String?> getPhoneClipboard(
  ConnectLaptopProvider connectLaptopProvider,
) async {
  String connLink = getConnLink(connectLaptopProvider.remoteIP!,
      connectLaptopProvider.remotePort!, EndPoints.getClipboard);
  logger.i(connLink);
  var res = await Dio().get(connLink);
  String clipboard = (res.data);
  if (clipboard.isEmpty) {
    return null;
  } else {
    return clipboard;
  }
}

// Future<void> startDownloadFile(
//   String filePath,
//   int fileSize,
//   BuildContext context,
// ) async {
//   String connLink =
//       connectLaptopPF(context).getPhoneConnLink(EndPoints.startDownloadFile);
//   await Dio().post(
//     connLink,
//     data: filePath,
//     options: Options(
//       headers: {
//         KHeaders.fileSizeHeaderKey: fileSize,
//       },
//     ),
//   );
// }

Future<void> downloadFolderUtil({
  required String remoteDeviceID,
  required String remoteFilePath,
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required String remoteDeviceName,
}) async {
  downPF(navigatorKey.currentContext!).addDownloadTask(
    remoteEntityPath: remoteFilePath,
    size: null,
    remoteDeviceID: remoteDeviceID,
    remoteDeviceName: remoteDeviceName,
    serverProvider: serverProvider,
    shareProvider: shareProvider,
    entityType: EntityType.folder,
  );
}

Future<void> startSendEntities(
  List<CapturedEntityModel> entities,
  BuildContext context,
) async {
  try {
    var data = entities.map((e) => e.toJSON()).toList();
    var encodedData = json.encode(data);
    String connLink =
        connectLaptopPF(context).getPhoneConnLink(EndPoints.startDownloadFile);
    await Dio().post(
      connLink,
      data: encodedData,
    );
  } on DioError catch (e) {
    logger.e(e.response?.data);
  }
}
