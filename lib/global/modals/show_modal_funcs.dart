// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/ask_for_share_space_modal.dart';
import 'package:explorer/global/modals/entity_info_modal.dart';
import 'package:explorer/global/modals/current_active_dir_options_modal.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/details_modal/details_modal.dart';
import 'package:explorer/global/modals/entity_options_modal.dart';
import 'package:explorer/global/modals/sort_by_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;
import 'package:qr_flutter/qr_flutter.dart';

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
      title: 'File Extension Change.',
      subTitle: 'If you changed a file extension it might not work.',
      okText: 'Rename',
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
      title: title ?? 'Confirm Delete',
      subTitle: subTitle ?? 'Do you want to delete selected items?',
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
