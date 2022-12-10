// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

enum CleanerItem {
  bigFiles,
  oldFiles,
}

class CleanerItemsScreen extends StatefulWidget {
  static const String routeName = '/CleanerItemsScreen';
  const CleanerItemsScreen({super.key});

  @override
  State<CleanerItemsScreen> createState() => _CleanerItemsScreenState();
}

class _CleanerItemsScreenState extends State<CleanerItemsScreen> {
  // bool loading = true;
  // List<StorageItemModel> children = [];
  // int? parentSize;
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((value) async {
  //     Map<String, dynamic> data =
  //         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  //     int extSize = data['size'];
  //     List<String> filesPaths = data['files'];
  //     var futures = filesPaths.map(
  //       (e) async {
  //         File file = File(e);
  //         FileStat fileStat = await file.stat();
  //         return StorageItemModel(
  //           parentPath: file.parent.path,
  //           path: file.path,
  //           modified: fileStat.modified,
  //           accessed: fileStat.accessed,
  //           changed: fileStat.changed,
  //           entityType: EntityType.file,
  //           size: fileStat.size,
  //         );
  //       },
  //     ).toList();
  //     var storageModels = await Future.wait(futures);
  //     storageModels.sort((a, b) => b.size!.compareTo(a.size!));
  //     if (mounted) {
  //       setState(() {
  //         children = storageModels;
  //         parentSize = extSize;
  //         loading = false;
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    CleanerItem cleanerItem =
        ModalRoute.of(context)!.settings.arguments as CleanerItem;
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    List<LocalFileInfo> allFilesInfo =
        analyzerProvider.advancedStorageAnalyzer?.filesInfo ?? [];
    if (cleanerItem == CleanerItem.bigFiles) {
      allFilesInfo.sort(
        (a, b) => b.size.compareTo(a.size),
      );
      allFilesInfo = allFilesInfo.sublist(0, 100);
    } else if (cleanerItem == CleanerItem.oldFiles) {
      allFilesInfo.sort(
        (a, b) => a.accessed.compareTo(b.accessed),
      );
      allFilesInfo = allFilesInfo.sublist(0, 100);
    }

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: allFilesInfo.map((e) {
          return ButtonWrapper(
            borderRadius: 0,
            onTap: () async {
              await OpenFile.open(e.path);
            },
            child: ChildFileItem(
              isSelected: false,
              storageItemModel: e.toStorageItemModel(),
              sizesExplorer: false,
              parentSize: 0,
            ),
          );
        }).toList(),
      ),
    );
  }
}
