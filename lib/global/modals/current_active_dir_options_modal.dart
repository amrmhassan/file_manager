// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentActiveDirOptionsModal extends StatelessWidget {
  const CurrentActiveDirOptionsModal({
    Key? key,
  }) : super(key: key);

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
          ModalButtonElement(
            title: 'Show Hidden Files',
            onTap: () {
              var expProvider =
                  Provider.of<ExplorerProvider>(context, listen: false);
              expProvider.toggleShowHiddenFiles();
              Navigator.pop(context);
            },
            checked: Provider.of<ExplorerProvider>(context, listen: false)
                .showHiddenFiles,
          ),
          ModalButtonElement(
            title: 'Folders First',
            onTap: () {
              var expProvider =
                  Provider.of<ExplorerProvider>(context, listen: false);
              expProvider.togglePriotorizeFolders();
              Navigator.pop(context);
            },
            checked: Provider.of<ExplorerProvider>(context, listen: false)
                .prioritizeFolders,
          ),
          ModalButtonElement(
            title: 'Create Folder',
            onTap: () {
              Navigator.pop(context);
              createNewFolderModal(context);
            },
          ),
          ModalButtonElement(
            title: 'Sort By ..',
            onTap: () {
              Navigator.pop(context);
              sortByModal(context);
            },
          ),
          ModalButtonElement(
            title: 'Search Files',
            onTap: () {
              showSnackBar(
                  context: context,
                  message: 'Coming soon, will search files, folders');
            },
          ),
          VSpace(),
        ],
      ),
    );
  }
}
