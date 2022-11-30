// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum RecentType {
  image,
  video,
  doc,
  music,
  apk,
  download,
  archives,
  social,
}

class RecentItemsViewerScreen extends StatefulWidget {
  static const String routeName = '/RecentItemsViewerScreen';
  const RecentItemsViewerScreen({super.key});

  @override
  State<RecentItemsViewerScreen> createState() =>
      _RecentItemsViewerScreenState();
}

class _RecentItemsViewerScreenState extends State<RecentItemsViewerScreen> {
  List<LocalFileInfo> viewedItems = [];

  void loadData() {
    Future.delayed(Duration.zero).then((value) {
      RecentType recentType =
          ModalRoute.of(context)!.settings.arguments as RecentType;
      if (recentType == RecentType.image) {
        Provider.of<RecentProvider>(context, listen: false).loadImages();
      }
    });
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var recentProvider = Provider.of<RecentProvider>(context);
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: recentProvider.imagesFiles.length,
              itemBuilder: (context, index) {
                LocalFileInfo localFileInfo = recentProvider.imagesFiles[index];

                return StorageItem(
                  storageItemModel: localFileInfo.toStorageItemModel(),
                  sizesExplorer: false,
                  parentSize: 0,
                  onDirTapped: (path) {},
                );
              },
            ),
          ),
          if (!foProvider.loadingOperation) EntityOperations(),
        ],
      ),
    );
  }
}
