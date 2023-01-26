// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharedItems extends StatelessWidget {
  const SharedItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaddingWrapper(
          child: Text(
            'Shared Items',
            style: h4TextStyleInactive,
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: shareProvider.sharedItems.length + 1,
            itemBuilder: (context, index) {
              if (index == shareProvider.sharedItems.length) {
                return SizedBox(
                  height: 50,
                );
              }
              ShareSpaceItemModel shareSpaceItemModel =
                  shareProvider.sharedItems[index];
              // StorageItemModel? storageItemModel = storageModelFromPath(
              //     shareProvider.sharedItems[index].path,
              //     shareProvider.sharedItems[index].entityType);
              // if (storageItemModel == null) {
              //   return SizedBox();
              // }
              return StorageItem(
                allowSelect: false,
                shareSpaceItemModel: shareSpaceItemModel,
                onDirTapped: (e) {},
                sizesExplorer: false,
                parentSize: 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
