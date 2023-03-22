// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/delete_button.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_options.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/share_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChooseOperationControllers extends StatelessWidget {
  const ChooseOperationControllers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShareButton(),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'copy',
            onTap: () {
              foProviderFalse.setOperation(FileOperation.copy);
            }),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'scissors',
            onTap: () {
              foProviderFalse.setOperation(FileOperation.move);
            }),
        HSpace(factor: .5),
        DeleteButton(),
        HSpace(factor: .5),
        EntityOptions(),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'close1',
            onTap: () {
              var expProvider =
                  Provider.of<ExplorerProvider>(context, listen: false);
              foProviderFalse.clearAllSelectedItems(expProvider);
            }),
      ],
    );
  }
}
