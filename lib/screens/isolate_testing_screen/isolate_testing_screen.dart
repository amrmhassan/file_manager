// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<FolderTree> getFolderTree() async {
  StorageAnalyser storageAnalyser = StorageAnalyser('sdcard/Songs');
  FolderTree folderTree = await storageAnalyser.getFolderTree();
  return folderTree;
}

class IsolateTestingScreen extends StatefulWidget {
  static const String routeName = '/isolate-testing-screen';
  const IsolateTestingScreen({super.key});

  @override
  State<IsolateTestingScreen> createState() => _IsolateTestingScreenState();
}

class _IsolateTestingScreenState extends State<IsolateTestingScreen> {
  bool loading = false;
  FolderTree? folderTree;

  Future<void> analyzeStorage() async {
    setState(() {
      loading = true;
    });
    if (await Permission.storage.request().isGranted) {
      FolderTree? f = await compute((msg) => getFolderTree(), null);
      setState(() {
        loading = false;
        folderTree = f;
      });
    } else {
      printOnDebug('Permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (folderTree != null) Text(folderTree!.totalSize.toMB.toString()),
            ElevatedButton(
              onPressed: loading ? () {} : analyzeStorage,
              child: Text(loading ? 'Running...' : 'Click Me'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('dummy button'),
            ),
          ],
        ),
      ),
    );
  }
}
