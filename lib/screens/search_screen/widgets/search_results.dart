// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var searchProvider = searchP(context);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: searchProvider.searchResults.length,
      itemBuilder: (context, index) {
        StorageItemModel storageItemModel =
            LocalFileInfo.fromPath(searchProvider.searchResults[index])
                .toStorageItemModel();
        return StorageItem(
          onDirTapped: (p) {
            handleOpenTabFromOtherScreen(p, context);
          },
          sizesExplorer: false,
          parentSize: 0,
          storageItemModel: storageItemModel,
        );
      },
    );
  }
}
