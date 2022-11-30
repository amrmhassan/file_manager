// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
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
  bool loading = true;

  //? to get the file info by index
  LocalFileInfo getFileInfo(int index) {
    RecentType recentType =
        ModalRoute.of(context)!.settings.arguments as RecentType;
    var recentProvider = Provider.of<RecentProvider>(context, listen: false);
    if (recentType == RecentType.image) {
      return recentProvider.imagesFiles[index];
    } else if (recentType == RecentType.video) {
      return recentProvider.videosFiles[index];
    } else if (recentType == RecentType.apk) {
      return recentProvider.apkFiles[index];
    } else if (recentType == RecentType.archives) {
      return recentProvider.archivesFiles[index];
    } else if (recentType == RecentType.doc) {
      return recentProvider.docsFiles[index];
    } else {
      return recentProvider.musicFiles[index];
    }
  }

  //? get list length
  int getListLength() {
    RecentType recentType =
        ModalRoute.of(context)!.settings.arguments as RecentType;
    var recentProvider = Provider.of<RecentProvider>(context, listen: false);
    if (recentType == RecentType.image) {
      return recentProvider.imagesFiles.length;
    } else if (recentType == RecentType.video) {
      return recentProvider.videosFiles.length;
    } else if (recentType == RecentType.apk) {
      return recentProvider.apkFiles.length;
    } else if (recentType == RecentType.archives) {
      return recentProvider.archivesFiles.length;
    } else if (recentType == RecentType.doc) {
      return recentProvider.docsFiles.length;
    } else {
      return recentProvider.musicFiles.length;
    }
  }

//? load data on the provider
  void loadData() {
    Future.delayed(Duration.zero).then((value) async {
      RecentType recentType =
          ModalRoute.of(context)!.settings.arguments as RecentType;
      if (recentType == RecentType.image) {
        await Provider.of<RecentProvider>(context, listen: false).loadImages();
      } else if (recentType == RecentType.video) {
        await Provider.of<RecentProvider>(context, listen: false).loadVideos();
      } else if (recentType == RecentType.music) {
        await Provider.of<RecentProvider>(context, listen: false).loadMusic();
      } else if (recentType == RecentType.apk) {
        await Provider.of<RecentProvider>(context, listen: false).loadApk();
      } else if (recentType == RecentType.archives) {
        await Provider.of<RecentProvider>(context, listen: false)
            .loadArchives();
      } else if (recentType == RecentType.doc) {
        await Provider.of<RecentProvider>(context, listen: false).loadDocs();
      }
      setState(() {
        loading = false;
      });
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
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: getListLength(),
                    itemBuilder: (context, index) {
                      LocalFileInfo localFileInfo = getFileInfo(index);

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
