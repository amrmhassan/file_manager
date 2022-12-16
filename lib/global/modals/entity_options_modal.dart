// ignore_for_file: prefer_const_constructors

import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/modals/widgets/add_to_favorite_button.dart';
import 'package:explorer/global/modals/widgets/add_to_other_listy_button.dart';
import 'package:explorer/global/modals/widgets/open_in_new_tab_button.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:provider/provider.dart';

class EntityOptionsModal extends StatelessWidget {
  const EntityOptionsModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
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
          OpenInNewTabButton(),
          AddToFavoriteButton(foProviderFalse: foProviderFalse),
          AddToOtherListyButton(foProviderFalse: foProviderFalse),
          ModalButtonElement(
            inactiveColor: Colors.transparent,
            opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
            active: foProviderFalse.selectedItems.length == 1,
            title: 'Rename',
            onTap: () async {
              Navigator.pop(context);
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
    );
  }
}
