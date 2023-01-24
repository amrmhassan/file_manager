// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedItemsScreen extends StatelessWidget {
  static const String routeName = '/SelectedItemsScreen';
  const SelectedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Selected Items',
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          ...foProvider.selectedItems.map(
            (e) => Dismissible(
              key: Key(e.path),
              child: StorageItem(
                storageItemModel: e,
                onDirTapped: (dir) {},
                allowSelect: false,
                allowShowingFavIcon: false,
                sizesExplorer: false,
                parentSize: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
