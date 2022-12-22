// ignore_for_file: prefer_const_constructors

import 'package:explorer/models/types.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OpenInNewTabButton extends StatelessWidget {
  const OpenInNewTabButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);

    return foProviderFalse.selectedItems.length > 1 ||
            foProviderFalse.selectedItems.first.entityType == EntityType.file
        ? SizedBox()
        : ModalButtonElement(
            inactiveColor: Colors.transparent,
            opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
            active: foProviderFalse.selectedItems.length == 1,
            title: 'Open In New Tab',
            onTap: () async {
              Provider.of<ExplorerProvider>(context, listen: false).openTab(
                foProviderFalse.selectedItems.first.path,
                foProviderFalse,
              );
              foProviderFalse.clearAllSelectedItems(
                  Provider.of<ExplorerProvider>(context, listen: false));
              Navigator.pop(context);
            },
          );
  }
}
