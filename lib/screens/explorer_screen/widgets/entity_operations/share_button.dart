// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/global/modals/share_via_modal.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

void shareFileHandler(BuildContext context) {
  foPF(context).shareFiles(expPF(context));
}

class ShareButton extends StatefulWidget {
  const ShareButton({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var foProviderFalse = foPF(context);
    return OperationButton(
      iconName: 'send',
      onTap: () {
        if (foProviderFalse.selectedItems.length == 1 &&
            foProviderFalse.selectedItems.first.entityType == EntityType.file) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => ShareViewModal(),
          );
        } else {
          shareFileHandler(context);
        }
      },
    );
  }
}
