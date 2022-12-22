// ignore_for_file: prefer_const_constructors

import 'package:explorer/models/types.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/screens/listy_screen/listy_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToOtherListyButton extends StatelessWidget {
  const AddToOtherListyButton({
    Key? key,
    required this.foProviderFalse,
  }) : super(key: key);

  final FilesOperationsProvider foProviderFalse;

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return foProviderFalse.selectedItems.length > 1
        ? SizedBox()
        : ModalButtonElement(
            inactiveColor: Colors.transparent,
            opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
            active: foProviderFalse.selectedItems.length == 1,
            title: 'Add To Other Listy',
            onTap: () async {
              String path = foProviderFalse.selectedItems.first.path;
              EntityType entityType =
                  foProviderFalse.selectedItems.first.entityType;
              foProviderFalse.clearAllSelectedItems(
                  Provider.of<ExplorerProvider>(context, listen: false));
              Navigator.pop(context);
              Navigator.pushNamed(context, ListyScreen.routeName, arguments: {
                'path': path,
                'type': entityType,
              });
            },
          );
  }
}
