// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
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
      .get(connectLaptopPF(context).getPhoneConnLink(getStorageEndPoint));
  int freeSpace = int.parse(res.headers.value(freeSpaceHeaderKey)!);
  int totalSpace = int.parse(res.headers.value(totalSpaceHeaderKey)!);

  return {
    freeSpaceHeaderKey: freeSpace,
    totalSpaceHeaderKey: totalSpace,
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
        shareSpace ? getShareSpaceEndPoint : getPhoneFolderContentEndPoint);

    var res = await Dio().get(
      connLink,
      options: shareSpace
          ? null
          : Options(
              headers: {
                folderPathHeaderKey: Uri.encodeComponent(folderPath),
              },
            ),
    );
    var data = res.data as List;
    String? folderPathRetrieved;
    folderPathRetrieved =
        Uri.decodeComponent(res.headers.value(parentFolderPathHeaderKey) ?? '');
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
      connectLaptopProvider.remotePort!, getClipboardEndPoint);
  logger.i(connLink);
  var res = await Dio().get(connLink);
  String clipboard = (res.data);
  if (clipboard.isEmpty) {
    return null;
  } else {
    return clipboard;
  }
}

Future<void> startDownloadFile(
  String filePath,
  int fileSize,
  BuildContext context,
) async {
  String connLink =
      connectLaptopPF(context).getPhoneConnLink(startDownloadFileEndPoint);
  await Dio().post(
    connLink,
    data: filePath,
    options: Options(
      headers: {
        fileSizeHeaderKey: fileSize,
      },
    ),
  );
}

Future<void> downloadFolder({
  required String remoteDeviceID,
  required String remoteFilePath,
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required String remoteDeviceName,
}) async {
  late BuildContext modalContext;
  try {
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
                Text('Loading Info'),
              ],
            ));
      },
    );
    String connLink = connectLaptopPF(navigatorKey.currentContext!)
        .getPhoneConnLink(getFolderContentRecrusiveEndPoint);
    var res = await Dio().get(
      connLink,
      options: Options(
        headers: {
          folderPathHeaderKey: Uri.encodeComponent(remoteFilePath),
        },
      ),
    );
    try {
      Navigator.pop(modalContext);
    } catch (e) {
      logger.e(e);
    }
    var data = res.data as List;
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    for (var item
        in items.where((element) => element.entityType == EntityType.folder)) {
      logger.i('${item.path}=>${item.entityType}=>${item.size}');
    }
    int size = items.fold(
        0, (previousValue, element) => previousValue + (element.size ?? 0));

    downPF(navigatorKey.currentContext!).addDownloadTask(
      remoteEntityPath: remoteFilePath,
      size: size,
      remoteDeviceID: remoteDeviceID,
      remoteDeviceName: remoteDeviceName,
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      entityType: EntityType.folder,
    );
  } on DioError catch (e) {
    logger.i(e.response?.data);
    logger.i(e.message);
    logger.i(e.type);
  }
}
