// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class AddToFavoriteButton extends StatelessWidget {
  const AddToFavoriteButton({
    Key? key,
    required this.foProviderFalse,
  }) : super(key: key);

  final FilesOperationsProvider foProviderFalse;

//? add to favorite
  Future addToFavorite(BuildContext context) async {
    await Provider.of<ListyProvider>(context, listen: false).addItemToListy(
      path: foProviderFalse.selectedItems.first.path,
      listyTitle: defaultListyList.first.title,
      entityType: foProviderFalse.selectedItems.first.entityType,
    );
    foProviderFalse.clearAllSelectedItems(
        Provider.of<ExplorerProvider>(context, listen: false));
    Navigator.pop(context);
  }

//? remove from favorite
  Future removeFromFavorite(BuildContext context) async {
    await Provider.of<ListyProvider>(context, listen: false)
        .removeItemFromListy(
      path: foProviderFalse.selectedItems.first.path,
      listyTitle: defaultListyList.first.title,
    );
    foProviderFalse.clearAllSelectedItems(
        Provider.of<ExplorerProvider>(context, listen: false));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var listyProviderFalse = Provider.of<ListyProvider>(context, listen: false);
    return foProviderFalse.selectedItems.length > 1
        ? SizedBox()
        : FutureBuilder(
            future: listyProviderFalse.itemExistInAListy(
              path: foProviderFalse.selectedItems.first.path,
              listyTitle: defaultListyList.first.title,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ModalButtonElement(
                  inactiveColor: Colors.transparent,
                  title: 'add-to-favorite'.i18n(),
                  onTap: () => addToFavorite(context),
                );
              } else if (snapshot.data == true) {
                return ModalButtonElement(
                  inactiveColor: Colors.transparent,
                  title: 'remove-from-favorite'.i18n(),
                  onTap: () => removeFromFavorite(context),
                );
              } else {
                return ModalButtonElement(
                  inactiveColor: Colors.transparent,
                  title: 'add-to-favorite'.i18n(),
                  onTap: () => addToFavorite(context),
                );
              }
            });
  }
}
