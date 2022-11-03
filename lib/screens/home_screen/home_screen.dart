// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/home_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/home_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:explorer/screens/home_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/files_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'isolates/load_folder_children_isolates.dart';

final Directory initialDir = Directory('sdcard');

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Directory currentActiveDir = initialDir;
  int exitCounter = 0;
  List<FileSystemEntityInfo> viewedChildren = [];
  String? error;
  bool loading = false;

  //? update viewed children
  void updateViewChildren(String path) async {
    try {
      setState(() {
        loading = true;
      });
      List<FileSystemEntityInfo> children =
          await compute(getFolderChildrenIsolate, currentActiveDir.path);
      //* don't update if the user clicked another folder because he can't wait to a large folder folder to load
      if (loading == false) return;
      if (prioritizeFolders) {
        List<FileSystemEntityInfo> folders = children
            .where((element) => isDir(element.fileSystemEntity.path))
            .toList();
        List<FileSystemEntityInfo> files = children
            .where((element) => isFile(element.fileSystemEntity.path))
            .toList();
        children = [...folders, ...files];
      }
      setState(() {
        viewedChildren = children;
        error = null;
      });
    } catch (e, s) {
      printOnDebug(e);
      printOnDebug(s);
      setState(() {
        viewedChildren.clear();
        error = e.toString();
      });
    }
    setState(() {
      loading = false;
    });
  }

  //? this will handle what happen when clicking a folder
  void updateActivePath(FileSystemEntity folder) {
    setState(() {
      currentActiveDir = Directory(folder.path);
    });
    updateViewChildren(currentActiveDir.path);
  }

//? handling going back in path
  void goBack() {
    if (currentActiveDir.parent.path == '.') return;
    updateActivePath(currentActiveDir.parent);
  }

  //? to catch clicking the phone back button
  Future<bool> handlePressPhoneBackButton() {
    bool exit = false;
    String cp = currentActiveDir.path;
    String ip = initialDir.path;
    if (cp == ip) {
      exitCounter++;
      if (exitCounter <= 1) {
        showSnackBar(context: context, message: 'Back Again To Exit');
        exit = false;
      } else {
        exit = true;
      }
    } else {
      exit = false;
    }
    goBack();
    //* to reset the exit counter after 2 seconds
    Future.delayed(Duration(seconds: 5)).then((value) {
      exitCounter = 0;
    });
    return Future.delayed(Duration.zero).then((value) => exit);
  }

  @override
  void initState() {
    //? getting storage permission
    Future.delayed(Duration.zero).then((value) async {
      if (await Permission.storage.isDenied) {
        //! show a modal first
        var readPermission = await Permission.storage.request();
        var managePermission = await Permission.manageExternalStorage.request();

        if (readPermission.isDenied ||
            readPermission.isPermanentlyDenied ||
            managePermission.isDenied ||
            managePermission.isPermanentlyDenied) {
          printOnDebug('Permission not granted');
          showSnackBar(
            context: context,
            message: 'Permission Not Granted',
            snackBarType: SnackBarType.error,
          );
        }
      } else {
        updateViewChildren(currentActiveDir.path);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handlePressPhoneBackButton,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              HomeAppBar(
                goBack: goBack,
                loadingFolder: loading,
              ),
              HomeItemHLine(),
              CurrentPathViewer(currentActiveDir: currentActiveDir),
              HomeItemHLine(),
              VSpace(factor: .5),
              ChildrenViewList(
                clickFolder: updateActivePath,
                viewedChildren: viewedChildren,
                error: error,
              )
            ],
          ),
        ),
      ),
    );
  }
}
