// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
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

class RecentsViewerScreen extends StatefulWidget {
  static const String routeName = '/RecentItemsViewerScreen';
  const RecentsViewerScreen({super.key});

  @override
  State<RecentsViewerScreen> createState() => _RecentsViewerScreenState();
}

class _RecentsViewerScreenState extends State<RecentsViewerScreen> {
  bool loading = true;
  List<LocalFileInfo> recentFilesToView = [];

  //? to get the file info by index
  List<LocalFileInfo> getRecentItemsInfo() {
    RecentType recentType =
        ModalRoute.of(context)!.settings.arguments as RecentType;
    var recentProvider = Provider.of<RecentProvider>(context, listen: false);
    if (recentType == RecentType.image) {
      return recentProvider.imagesFiles;
    } else if (recentType == RecentType.video) {
      return recentProvider.videosFiles;
    } else if (recentType == RecentType.apk) {
      return recentProvider.apkFiles;
    } else if (recentType == RecentType.archives) {
      return recentProvider.archivesFiles;
    } else if (recentType == RecentType.doc) {
      return recentProvider.docsFiles;
    } else if (recentType == RecentType.download) {
      return recentProvider.downloadsFiles;
    } else {
      return recentProvider.musicFiles;
    }
  }

  //? get list length
  // int getListLength() {
  //   RecentType recentType =
  //       ModalRoute.of(context)!.settings.arguments as RecentType;
  //   var recentProvider = Provider.of<RecentProvider>(context, listen: false);
  //   if (recentType == RecentType.image) {
  //     return recentProvider.imagesFiles.length;
  //   } else if (recentType == RecentType.video) {
  //     return recentProvider.videosFiles.length;
  //   } else if (recentType == RecentType.apk) {
  //     return recentProvider.apkFiles.length;
  //   } else if (recentType == RecentType.archives) {
  //     return recentProvider.archivesFiles.length;
  //   } else if (recentType == RecentType.doc) {
  //     return recentProvider.docsFiles.length;
  //   } else if (recentType == RecentType.download) {
  //     return recentProvider.downloadsFiles.length;
  //   } else {
  //     return recentProvider.musicFiles.length;
  //   }
  // }

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
      } else if (recentType == RecentType.download) {
        await Provider.of<RecentProvider>(context, listen: false)
            .loadDownloads();
      }
      setState(() {
        loading = false;
        recentFilesToView = getRecentItemsInfo();
        recentFilesToView.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );
      });
      logger.i('length ${recentFilesToView.length}');
    });
  }

  String get title {
    RecentType recentType =
        ModalRoute.of(context)!.settings.arguments as RecentType;
    if (recentType == RecentType.image) {
      return 'images-text'.i18n();
    } else if (recentType == RecentType.video) {
      return 'videos-text'.i18n();
    } else if (recentType == RecentType.apk) {
      return 'apks-text'.i18n();
    } else if (recentType == RecentType.archives) {
      return 'archives-text'.i18n();
    } else if (recentType == RecentType.doc) {
      return 'docs-text'.i18n();
    } else if (recentType == RecentType.download) {
      return 'downloads-text'.i18n();
    } else if (recentType == RecentType.music) {
      return 'music-text'.i18n();
    } else {
      return '';
    }
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              '${"recent-2".i18n()} $title',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : recentFilesToView.isEmpty
                  ? Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no-recent-items-yet'.i18n(),
                          style: h4TextStyleInactive,
                        ),
                      ],
                    ))
                  : Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: recentFilesToView.length,
                        itemBuilder: (context, index) {
                          LocalFileInfo localFileInfo =
                              recentFilesToView[index];

                          return StorageItem(
                            storageItemModel:
                                localFileInfo.toStorageItemModel(),
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
