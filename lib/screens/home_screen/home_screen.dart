// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/children_view_list.dart';
import 'package:explorer/screens/home_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:explorer/screens/home_screen/widgets/file_item.dart';
import 'package:explorer/utils/general_utils.dart';

import 'package:explorer/analyzing_code/explorer_utils/scanning_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

final Directory initialDir = Directory('sdcard');

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileSystemEntity> folders = [];
  Directory currenActiveDir = initialDir;
  int exitCounter = 0;

  //? this will handle what happen when clicking a folder
  void clickFolder(FileSystemEntity folder) {
    setState(() {
      currenActiveDir = Directory(folder.path);
    });
  }

//? handling going back in path
  void goBack() {
    if (currenActiveDir.parent.path == '.') return;
    setState(() {
      currenActiveDir = currenActiveDir.parent;
    });
  }

  //? to catch clicking the phone back button
  Future<bool> handlePressPhoneBackButton() {
    bool exit = false;
    goBack();
    String cp = currenActiveDir.path;
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
    return Future.delayed(Duration.zero).then((value) => exit);
  }

  @override
  void initState() {
    //? getting storage permission
    Future.delayed(Duration.zero).then((value) async {
      if (await Permission.storage.isDenied) {
        //! show a modal first
        if (await Permission.storage.request().isGranted) {
        } else {
          printOnDebug('Permission not granted');
        }
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
              Row(
                children: [
                  AppBarIconButton(onTap: goBack, iconName: 'back'),
                  Spacer(),
                  ExplorerModeSwitcher(),
                  Spacer(),
                  AppBarIconButton(
                    onTap: () {
                      //? Add a new folder
                    },
                    iconName: 'plus',
                    color: Colors.white,
                  )
                ],
              ),
              HLine(
                thickness: 1,
                color: kInactiveColor.withOpacity(.1),
              ),
              CurrentPathViewer(currentActiveDir: currenActiveDir),
              HLine(
                thickness: 1,
                color: kInactiveColor.withOpacity(.1),
              ),
              VSpace(factor: .5),
              ChildrenViewList(
                clickFolder: clickFolder,
                currentActiveDir: currenActiveDir,
              )
            ],
          ),
        ),
      ),
    );
  }
}
