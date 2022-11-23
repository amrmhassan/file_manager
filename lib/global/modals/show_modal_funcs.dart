// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/create_folder_modal.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/single_item_details_modal.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

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
  //? rename modal
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: expScreenKey.currentContext!,
      builder: (_) {
        var foProvider = Provider.of<FilesOperationsProvider>(
            expScreenKey.currentContext!,
            listen: false);
        if (foProvider.selectedItems.length < 2) {
          StorageItemModel singleItem = foProvider.selectedItems[0];
          return SingleItemDetailsModal(singleItem: singleItem);
        } else {
          return Text('Details for multiple items');
        }
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
void confirmDeleteEntityModal(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DoubleButtonsModal(
      title: 'Confirm Delete',
      subTitle: 'Do you want to delete selected items?',
      onOk: () {
        //? here delete the items
        Provider.of<FilesOperationsProvider>(context, listen: false)
            .performDelete();
      },
    ),
  );
}

//? entity options modal
Future<void> showEntityOptionsModal(BuildContext context) async {
  var foProviderFalse =
      Provider.of<FilesOperationsProvider>(context, listen: false);
  //? entity options modal
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (ctx) => ModalWrapper(
      afterLinePaddingFactor: 0,
      bottomPaddingFactor: 0,
      padding: EdgeInsets.zero,
      color: kCardBackgroundColor,
      showTopLine: false,
      borderRadius: mediumBorderRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VSpace(),
          ModalButtonElement(
            inactiveColor: Colors.transparent,
            opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
            active: foProviderFalse.selectedItems.length == 1,
            title: 'Rename',
            onTap: () async {
              Navigator.pop(ctx);
              await showRenameModal(context);
            },
          ),
          ModalButtonElement(
            title: 'Details',
            onTap: () async {
              Navigator.pop(context);
              await showDetailsModal(
                context,
              );
            },
          ),
          VSpace(),
        ],
      ),
    ),
  );
}

//? add a new folder modal
void showCurrentActiveDirOptions(BuildContext context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return ModalWrapper(
          afterLinePaddingFactor: 0,
          bottomPaddingFactor: 0,
          padding: EdgeInsets.zero,
          color: kCardBackgroundColor,
          showTopLine: false,
          borderRadius: mediumBorderRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(),
              ModalButtonElement(
                title: 'Create Folder',
                onTap: () {
                  Navigator.pop(context);
                  createNewFolderModal(context);
                },
              ),
              VSpace(),
            ],
          ),
        );
      });
}

//? create new folder modal
void createNewFolderModal(BuildContext context) {
  //? Add a new folder after showing a modal

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return EntityInfoEditingModal();
      });
}
