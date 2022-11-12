// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PerformPasteOperationContoller extends StatelessWidget {
  const PerformPasteOperationContoller({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OperationButton(
            iconName: 'paste',
            onTap: () {
              var expProvider =
                  Provider.of<ExplorerProvider>(context, listen: false);
              foProviderFalse.performCopy(expProvider.currentActiveDir.path);
            }),
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
