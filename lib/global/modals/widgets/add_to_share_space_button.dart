import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/files_operations_provider.dart';
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
          Provider.of<ShareProvider>(context, listen: false)
              .removeMultipleItemsFromShareSpace(foProviderFalse.selectedItems);
        } else if (added == false) {
          Provider.of<ShareProvider>(context, listen: false)
              .addMultipleFilesToShareSpace(foProviderFalse.selectedItems);
        }
        foProviderFalse.clearAllSelectedItems(
            Provider.of<ExplorerProvider>(context, listen: false));
        Navigator.pop(context);
      },
    );
  }
}
