// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateFolderModal extends StatefulWidget {
  final String? oldName;

  const CreateFolderModal({
    Key? key,
    this.oldName,
  }) : super(key: key);

  @override
  State<CreateFolderModal> createState() => _CreateFolderModalState();
}

class _CreateFolderModalState extends State<CreateFolderModal> {
  TextEditingController nameController = TextEditingController();
  bool rename = false;
  String? orgFileExt;
  String? orgFileName;

//? handle apply modal
  void handleApplyModal() async {
    try {
      if (rename) {
        if (orgFileName == nameController.text) {
          showSnackBar(context: context, message: 'The name didn\'t change.');
        } else {
          EntityType entityType =
              Provider.of<FilesOperationsProvider>(context, listen: false)
                  .selectedItems
                  .first
                  .entityType;
          if (entityType == EntityType.folder) {
            handleRenameFolder();
          } else if (entityType == EntityType.file) {
            await handleRenameFile();
          }
        }
      } else {
        handleCreateNewFolder();
      }
    } catch (e) {
      showSnackBar(
          context: context,
          message: 'Error Occurred',
          snackBarType: SnackBarType.error);
    }

    Navigator.pop(context);
  }

  //? create new folder
  void handleCreateNewFolder() {
    if (nameController.text.trim().isEmpty) return;
    var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
    try {
      Provider.of<FilesOperationsProvider>(context, listen: false)
          .createFolder(nameController.text.trim(), expProvider);
      nameController.text = '';
      Navigator.pop(context);
    } catch (E) {
      Navigator.pop(context);

      showSnackBar(
        context: context,
        message: 'This Folder Already Exists',
        snackBarType: SnackBarType.error,
      );
    }
  }

  //? rename file
  Future<void> handleRenameFile([bool checkExt = true]) async {
    if (nameController.text.isEmpty) return;
    String newExt = '.${getFileExtension(nameController.text)}';

    if (orgFileExt != newExt && checkExt) {
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => DoubleButtonsModal(
          onOk: () {
            handleRenameFile(false);
          },
          title: 'File Extension Change.',
          subTitle: 'If you changed a file extension it might not work.',
          okText: 'Rename',
          okColor: Colors.blue,
        ),
      );
    } else {
      var foProvider =
          Provider.of<FilesOperationsProvider>(context, listen: false);
      var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
      String filePath = foProvider.selectedItems.first.path;
      foProvider.performRenameFile(
        newFileName: nameController.text,
        filePath: filePath,
        explorerProvider: expProvider,
      );
    }
  }

  //? rename folder
  void handleRenameFolder() {
    if (nameController.text.isEmpty) return;
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
    String folderPath = foProvider.selectedItems.first.path;
    foProvider.performRenameFolder(
      newFolderName: nameController.text,
      folderPath: folderPath,
      explorerProvider: expProvider,
    );
  }

  @override
  void initState() {
    nameController.text = widget.oldName ?? 'New Folder';
    if (widget.oldName != null) {
      rename = true;
      String ext = '.${getFileExtension(widget.oldName!)}';
      orgFileExt = ext;
      orgFileName = widget.oldName;
      int extStart = widget.oldName!.indexOf(ext);
      nameController.selection =
          TextSelection(baseOffset: 0, extentOffset: extStart);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          CustomTextField(
            title: 'Enter Folder Name',
            controller: nameController,
            autoFocus: true,
            color: kInactiveColor,
            textStyle: h4TextStyleInactive.copyWith(
              color: Colors.white,
            ),
          ),
          PaddingWrapper(
            child: Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    nameController.text = '';

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: h4TextStyleInactive,
                  ),
                ),
                HSpace(),
                TextButton(
                  onPressed: handleApplyModal,
                  child: Text(
                    rename ? 'Rename' : 'Create',
                    style: h4TextStyle,
                  ),
                ),
              ],
            ),
          ),
          VSpace(),
        ],
      ),
    );
  }
}
