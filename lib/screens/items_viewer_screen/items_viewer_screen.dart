// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/recent_opened_file_model.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/screen_utils/items_viewer_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

enum ItemsType {
  bigFiles,
  oldFiles,
  modifiedFiles,
  recentOpenedFiles,
}

class ItemsViewerScreen extends StatefulWidget {
  static const String routeName = '/CleanerItemsScreen';
  const ItemsViewerScreen({super.key});

  @override
  State<ItemsViewerScreen> createState() => _ItemsViewerScreenState();
}

class _ItemsViewerScreenState extends State<ItemsViewerScreen> {
  bool loading = false;
  List<LocalFileInfo> allFilesInfo = [];

//? to get the data that will be viewed
  Future<List<LocalFileInfo>> fetchData(ItemsType itemsType) async {
    var analyzerProvider =
        Provider.of<AnalyzerProvider>(context, listen: false);
    analyzerProvider.advancedStorageAnalyzer?.filesInfo;

    List<LocalFileInfo> allFilesInfo =
        analyzerProvider.advancedStorageAnalyzer?.filesInfo ?? [];
    if (itemsType == ItemsType.bigFiles) {
      allFilesInfo.sort(
        (a, b) => b.size.compareTo(a.size),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
      return allFilesInfo;
    } else if (itemsType == ItemsType.oldFiles) {
      allFilesInfo.sort(
        (a, b) => a.accessed.compareTo(b.accessed),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
      return allFilesInfo;
    } else if (itemsType == ItemsType.modifiedFiles) {
      allFilesInfo.sort(
        (a, b) => a.modified.compareTo(b.modified),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
      return allFilesInfo;
    } else if (itemsType == ItemsType.recentOpenedFiles) {
      var data = await DBHelper.getDataLimit(
        limit: 100,
        table: recentlyOpenedFilesTableName,
        databaseName: persistentDbName,
        orderASC: false,
        orderProp: dateFileOpenedString,
      );
      List<RecentOpenedFileModel> recentFiles = [];
      for (var element in data) {
        recentFiles.add(RecentOpenedFileModel.fromJSON(element));
      }
      return pathsToStorageItems(recentFiles.map((e) => e.path))
          .map((e) => e.toLocalFileInfo())
          .toList();
    } else {
      return [];
    }
  }

//! fix this page to view files according to their type
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      ItemsType itemsType =
          ModalRoute.of(context)!.settings.arguments as ItemsType;
      var data = await fetchData(itemsType);
      setState(() {
        allFilesInfo = data;
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: allFilesInfo.map((e) {
                return ButtonWrapper(
                  borderRadius: 0,
                  onTap: () async {
                    await OpenFile.open(e.path);
                  },
                  child: StorageItem(
                    onDirTapped: ((path) {}),
                    storageItemModel: e.toStorageItemModel(),
                    sizesExplorer: false,
                    parentSize: 0,
                  ),
                );
              }).toList(),
            ),
          ),
          if (!foProvider.loadingOperation) EntityOperations(),
        ],
      ),
    );
  }
}
