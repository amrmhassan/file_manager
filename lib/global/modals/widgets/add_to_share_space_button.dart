// ignore_for_file: use_build_context_synchronously

import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToShareSpaceButton extends StatefulWidget {
  const AddToShareSpaceButton({
    Key? key,
  }) : super(key: key);

  @override
  State<AddToShareSpaceButton> createState() => _AddToShareSpaceButtonState();
}

class _AddToShareSpaceButtonState extends State<AddToShareSpaceButton> {
  bool? added;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      List<StorageItemModel> selectedItems =
          Provider.of<FilesOperationsProvider>(context, listen: false)
              .selectedItems;
      bool res = await Provider.of<ShareProvider>(context, listen: false)
          .areAllItemsAtShareSpace(selectedItems);
      setState(() {
        added = res;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return ModalButtonElement(
      inactiveColor: Colors.transparent,
      title: added == null
          ? '...'
          : added == true
              ? 'Remove From Share Space'
              : 'Add To Share Space',
      onTap: () async {
        if (added == true) {
          //? remove from share space
          var shareProviderFalse =
              Provider.of<ShareProvider>(context, listen: false);
          var serverProviderFalse =
              Provider.of<ServerProvider>(context, listen: false);
          await shareProviderFalse
              .removeMultipleItemsFromShareSpace(foProviderFalse.selectedItems);

          //? broad cast files removal from share space
          //? i removed await to prevent the user waiting for the other device to respond
          client_utils.broadCastFileRemovalFromShareSpace(
            serverProvider: serverProviderFalse,
            shareProvider: shareProviderFalse,
            paths: foProviderFalse.selectedItems.map((e) => e.path).toList(),
          );
        } else if (added == false) {
          //? add to share space
          var shareProviderFalse =
              Provider.of<ShareProvider>(context, listen: false);
          var serverProviderFalse =
              Provider.of<ServerProvider>(context, listen: false);
          List<ShareSpaceItemModel> addedItems = await shareProviderFalse
              .addMultipleFilesToShareSpace(foProviderFalse.selectedItems);

          //? broad cast files addition from share space
          //? i removed await to prevent the user waiting for the other device to respond
          client_utils.broadCastFileAddedToShareSpace(
            serverProvider: serverProviderFalse,
            shareProvider: shareProviderFalse,
            addedItems: addedItems,
          );
        }
        foProviderFalse.clearAllSelectedItems(
            Provider.of<ExplorerProvider>(context, listen: false));
        Navigator.pop(context);
      },
    );
  }
}
