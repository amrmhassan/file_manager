// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:flutter/material.dart';

class EntityOptions extends StatelessWidget {
  const EntityOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OperationButton(
        iconName: 'dots',
        onTap: () async {
          showEntityOptionsModal(context);
        });
  }
}
