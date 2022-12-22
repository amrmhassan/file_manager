// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectAllButton extends StatelessWidget {
  const SelectAllButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);

    return ButtonWrapper(
      onTap: () {
        var currentDirChildren =
            Provider.of<ExplorerProvider>(context, listen: false).children;
        var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
        if (expProvider.allActiveDirChildrenSelected) {
          Provider.of<FilesOperationsProvider>(context, listen: false)
              .deselectAll(currentDirChildren, expProvider);
        } else {
          Provider.of<FilesOperationsProvider>(context, listen: false)
              .selectAll(currentDirChildren, expProvider);
        }
      },
      borderRadius: 0,
      padding: EdgeInsets.all(largePadding),
      child: Image.asset(
        expProvider.allActiveDirChildrenSelected
            ? 'assets/icons/deselect-all.png'
            : 'assets/icons/select-all.png',
        color: Colors.white,
        width: ultraLargeIconSize / 2,
      ),
    );
  }
}
