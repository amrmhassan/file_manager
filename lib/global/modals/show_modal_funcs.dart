// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/ask_for_share_space_modal.dart';
import 'package:explorer/global/modals/ask_permission_modal.dart';
import 'package:explorer/global/modals/entity_info_modal.dart';
import 'package:explorer/global/modals/current_active_dir_options_modal.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/details_modal/details_modal.dart';
import 'package:explorer/global/modals/entity_options_modal.dart';
import 'package:explorer/global/modals/sort_by_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/models/permission_result_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_to_laptop_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;
import 'package:qr_flutter/qr_flutter.dart';

Future<dynamic> showWaitPermissionModal(Future Function() callback) async {
  late BuildContext modalContext;

  var data = await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: navigatorKey.currentContext!,
    builder: (context) {
      modalContext = context;
      return FutureBuilder(
          future: callback(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Navigator.of(modalContext).pop(
                PermissionResultModel(
                  error: null,
                  result: snapshot.data,
                ),
              );
            } else if (snapshot.hasError) {
              showSnackBar(
                context: context,
                message: (snapshot.error as DioError).response?.data ??
                    'Error Occurred',
                snackBarType: SnackBarType.error,
              );
              Navigator.of(modalContext).pop(
                PermissionResultModel(
                  error: snapshot.error,
                  result: null,
                ),
              );
            }
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
              ),
            );
          });
    },
  );
  return data;
}

Future<bool> showAskForFeaturePermissionModal(
  String userName,
  String deviceID,
  PermissionName permissionName,
  BuildContext context,
) async {
  bool? res = await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => AskPermissionModal(
      userName: userName,
      deviceID: deviceID,
      permissionName: permissionName,
    ),
  );
  //? this wont consider remember
  //? so if it is null it will be blocked( no care if it is remembered or not)
  return res == true;
}

//?
Future<bool> showAskForShareSpaceModal(
  String userName,
  String deviceID,
  BuildContext context,
) async {
  bool? res = await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => AskForShareSpaceModal(
      userName: userName,
      deviceID: deviceID,
    ),
  );

  if (res == null) {
    await serverPF(context).blockDevice(deviceID, false, true);
  }

  return res ?? false;
}

//? show rename modal
Future<void> showRenameModal(BuildContext context) async {
  //? rename modal
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: expScreenKey.currentContext!,
      builder: (_) {
        String oldName = path_operations.basename(
            Provider.of<FilesOperationsProvider>(expScreenKey.currentContext!,
                    listen: false)
                .selectedItems[0]
                .path);
        return EntityInfoEditingModal(
          oldName: oldName,
        );
      });
}

//? show rename modal
Future<void> showDetailsModal(BuildContext context) async {
  //? details modal
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: expScreenKey.currentContext!,
      builder: (_) {
        var foProvider = Provider.of<FilesOperationsProvider>(
            expScreenKey.currentContext!,
            listen: false);
        // Provider.of<FilesOperationsProvider>(context, listen: false)
        //     .clearAllSelectedItems(
        //         Provider.of<ExplorerProvider>(context, listen: false), false);

        return SingleItemDetailsModal(selectedItems: foProvider.selectedItems);
        // return Container(
        //   height: 100,
        //   color: Colors.white,
        // );
      });
}

//? change file ext rename modal
Future<void> showFileExtChangeModal(BuildContext context,
    Function(BuildContext context, bool checkExt) handleRenameFile) async {
  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: expScreenKey.currentContext!,
    builder: (ctx) => DoubleButtonsModal(
      onOk: () {
        handleRenameFile(context, false);
      },
      title: 'file-ext-change'.i18n(),
      subTitle: 'file-ext-change-note'.i18n(),
      okText: 'rename'.i18n(),
      okColor: kBlueColor,
    ),
  );
}

//? confirm delete modal
void confirmDeleteEntityModal({
  required BuildContext context,
  String? title,
  String? subTitle,
  VoidCallback? onOk,
  VoidCallback? onCancel,
  String? cancelText,
  String? okText,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DoubleButtonsModal(
      cancelText: cancelText,
      onCancel: onCancel,
      okText: okText,
      title: title ?? 'confirm-delete'.i18n(),
      subTitle: subTitle ?? 'confirm-delete-note'.i18n(),
      onOk: onOk ??
          () {
            var expProvider =
                Provider.of<ExplorerProvider>(context, listen: false);
            //? here delete the items
            Provider.of<FilesOperationsProvider>(context, listen: false)
                .performDelete(expProvider);
          },
    ),
  );
}

//? entity options modal
Future<void> showEntityOptionsModal(BuildContext context) async {
  //? entity options modal
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => EntityOptionsModal(),
  );
}

//? add a new folder modal
void showCurrentActiveDirOptions(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return CurrentActiveDirOptionsModal();
      });
}

//? create new folder modal
void createNewFolderModal(BuildContext context, [bool createListy = false]) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) {
      return EntityInfoEditingModal(
        createListy: createListy,
      );
    },
  );
}

//? sort by modal
void sortByModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => SortByModal(),
  );
}

Future showQrCodeModal(BuildContext context) async {
  var serverProvider = Provider.of<ServerProvider>(context, listen: false);

  String connLink = serverProvider.myConnLink!;

  await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => ModalWrapper(
      color: kBackgroundColor,
      showTopLine: false,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          copyToClipboard(context, connLink);
        },
        child: SizedBox(
          child: Column(
            children: [
              QrImage(
                backgroundColor: Colors.white,
                data: connLink,
                size: 150,
              ),
              Text(connLink),
            ],
          ),
        ),
      ),
    ),
  );
}

void showDownloadFromShareSpaceModal(
  BuildContext context,
  PeerModel? peerModel,
  int index,
) async {
  var shareExpProvider = shareExpPF(context);
  ShareSpaceItemModel shareSpaceItemModel = shareExpProvider.viewedItems[index];
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => ModalWrapper(
      padding: EdgeInsets.symmetric(
        vertical: kVPad / 2,
      ),
      bottomPaddingFactor: 0,
      afterLinePaddingFactor: 0,
      showTopLine: false,
      color: kBackgroundColor,
      child: Column(
        children: [
          ModalButtonElement(
            inactiveColor: Colors.transparent,
            title: 'download-now'.i18n(),
            onTap: () async {
              if (shareSpaceItemModel.entityType == EntityType.folder) {
                Navigator.pop(context);
                await downloadFolderUtil(
                  remoteDeviceID: peerModel?.deviceID ?? laptopID,
                  remoteDeviceName: peerModel?.name ?? laptopName,
                  remoteFilePath: shareSpaceItemModel.path,
                  serverProvider: serverPF(context),
                  shareProvider: sharePF(context),
                );
              } else {
                try {
                  await Provider.of<DownloadProvider>(
                    context,
                    listen: false,
                  ).addDownloadTask(
                    size: shareSpaceItemModel.size,
                    remoteDeviceID: peerModel?.deviceID ?? laptopID,
                    remoteEntityPath: shareSpaceItemModel.path,
                    serverProvider: serverPF(context),
                    shareProvider: sharePF(context),
                    entityType: EntityType.file,
                    remoteDeviceName: peerModel?.name ?? laptopName,
                  );
                  Navigator.pop(context);
                } catch (e) {
                  logger.e(e);
                  showSnackBar(
                    context: context,
                    message: 'error-occurred'.i18n(),
                    snackBarType: SnackBarType.error,
                  );
                }
              }
            },
          ),
        ],
      ),
    ),
  );
}
