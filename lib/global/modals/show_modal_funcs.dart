// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/create_folder_modal.dart';
import 'package:explorer/global/modals/current_active_dir_options_modal.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/details_modal/details_modal.dart';
import 'package:explorer/global/modals/entity_options_modal.dart';
import 'package:explorer/global/modals/sort_by_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
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
void createNewFolderModal(BuildContext context) {
  //? Add a new folder after showing a modal

  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return EntityInfoEditingModal();
      });
}

//? sort by modal
void sortByModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => SortByModal(),
  );
}
