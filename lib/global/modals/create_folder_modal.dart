// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
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
  const CreateFolderModal({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateFolderModal> createState() => _CreateFolderModalState();
}

class _CreateFolderModalState extends State<CreateFolderModal> {
  TextEditingController folderNameController = TextEditingController();

  void handleCreateNewFolder(
    BuildContext context,
    TextEditingController folderNameController,
  ) {
    if (folderNameController.text.trim().isEmpty) return;
    var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
    try {
      Provider.of<FilesOperationsProvider>(context, listen: false)
          .createFolder(folderNameController.text.trim(), expProvider);
      folderNameController.text = '';
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

  @override
  void initState() {
    folderNameController.text = 'New Folder';
    folderNameController.selection = TextSelection(
        baseOffset: 0, extentOffset: folderNameController.text.length);
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
            controller: folderNameController,
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
                    folderNameController.text = '';

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: h4TextStyleInactive,
                  ),
                ),
                HSpace(),
                TextButton(
                  onPressed: () =>
                      {handleCreateNewFolder(context, folderNameController)},
                  child: Text(
                    'Create',
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
