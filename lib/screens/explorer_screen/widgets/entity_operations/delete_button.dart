// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OperationButton(
        iconName: 'delete',
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => DoubleButtonsModal(
              title: 'Confirm Delete',
              subTitle: 'Do you want to delete selected items?',
              onOk: () {
                //? here delete the items
                Provider.of<FilesOperationsProvider>(context, listen: false)
                    .performDelete();
              },
            ),
          );
        });
  }
}
