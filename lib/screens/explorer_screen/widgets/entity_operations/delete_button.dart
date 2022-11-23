// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OperationButton(
        iconName: 'delete',
        onTap: () {
          confirmDeleteEntityModal(context);
        });
  }
}
