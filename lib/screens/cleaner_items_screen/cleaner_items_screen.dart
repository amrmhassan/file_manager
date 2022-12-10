// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

enum CleanerItem {
  bigFiles,
  oldFiles,
  modifiedFiles,
}

class CleanerItemsScreen extends StatefulWidget {
  static const String routeName = '/CleanerItemsScreen';
  const CleanerItemsScreen({super.key});

  @override
  State<CleanerItemsScreen> createState() => _CleanerItemsScreenState();
}

class _CleanerItemsScreenState extends State<CleanerItemsScreen> {
  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    CleanerItem cleanerItem =
        ModalRoute.of(context)!.settings.arguments as CleanerItem;
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    List<LocalFileInfo> allFilesInfo =
        analyzerProvider.advancedStorageAnalyzer?.filesInfo ?? [];
    if (cleanerItem == CleanerItem.bigFiles) {
      allFilesInfo.sort(
        (a, b) => b.size.compareTo(a.size),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
    } else if (cleanerItem == CleanerItem.oldFiles) {
      allFilesInfo.sort(
        (a, b) => a.accessed.compareTo(b.accessed),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
    } else if (cleanerItem == CleanerItem.modifiedFiles) {
      allFilesInfo.sort(
        (a, b) => a.modified.compareTo(b.modified),
      );
      allFilesInfo = allFilesInfo.sublist(0, 200);
    }

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
