import 'package:dio/dio.dart';
import 'package:explorer/providers/connect_laptop_provider.dart';
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

Future<void> getPhoneFolderContent({
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

    shareItemsExplorerProvider.setLoadingItems(false, false);
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
  var res = await Dio().get(connLink);
  String clipboard = (res.data);
  if (clipboard.isEmpty) {
    return null;
  } else {
    return clipboard;
  }
}
