// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/explorer_screen/widgets/child_file_item.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ExtFilesScreen extends StatefulWidget {
  static const String routeName = '/ext-files-screen';
  const ExtFilesScreen({super.key});

  @override
  State<ExtFilesScreen> createState() => _ExtFilesScreenState();
}

class _ExtFilesScreenState extends State<ExtFilesScreen> {
  bool loading = true;
  List<StorageItemModel> children = [];
  int? parentSize;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Map<String, dynamic> data =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      int extSize = data['size'];
      List<String> filesPaths = data['files'];
      var futures = filesPaths.map(
        (e) async {
          File file = File(e);
          FileStat fileStat = await file.stat();
          return StorageItemModel(
            parentPath: file.parent.path,
            path: file.path,
            modified: fileStat.modified,
            accessed: fileStat.accessed,
            changed: fileStat.changed,
            entityType: EntityType.file,
            size: fileStat.size,
          );
        },
      ).toList();
      var storageModels = await Future.wait(futures);
      storageModels.sort((a, b) => b.size!.compareTo(a.size!));
      if (mounted) {
        setState(() {
          children = storageModels;
          parentSize = extSize;
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: loading
          ? Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView(
              physics: BouncingScrollPhysics(),
              children: children.map((e) {
                return ButtonWrapper(
                  borderRadius: 0,
                  onTap: () async {
                    await OpenFile.open(e.path);
                  },
                  child: ChildFileItem(
                    isSelected: false,
                    storageItemModel: e,
                    sizesExplorer: true,
                    parentSize: parentSize ?? 0,
                  ),
                );
              }).toList(),
            ),
    );
  }
}
