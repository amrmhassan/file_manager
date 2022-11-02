// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/home_screen/widgets/file_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:path/path.dart' as path;

import 'package:explorer/analyzing_code/explorer_utils/scanning_utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FileSystemEntity> folders = [];
  Directory currenActiveDir = Directory('sdcard');

  void clickFolder(FileSystemEntity folder) {
    setState(() {
      currenActiveDir = Directory(folder.path);
    });
  }

  void goBack() {
    if (currenActiveDir.parent.path == '.') return;
    setState(() {
      currenActiveDir = currenActiveDir.parent;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      if (await Permission.storage.isDenied) {
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
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                ButtonWrapper(
                  onTap: goBack,
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad,
                    vertical: kVPad,
                  ),
                  child: Image.asset(
                    'assets/icons/back.png',
                    width: largeIconSize / 2,
                    color: kInactiveColor,
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kHPad,
                        vertical: kVPad / 2,
                      ),
                      decoration: BoxDecoration(
                        color: kCardBackgroundColor,
                        borderRadius: BorderRadius.circular(smallBorderRadius),
                      ),
                      child: Image.asset(
                        'assets/icons/chart.png',
                        width: smallIconSize,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kHPad,
                        vertical: kVPad / 2,
                      ),
                      decoration: BoxDecoration(
                        color: kLightCardBackgroundColor,
                        borderRadius: BorderRadius.circular(smallBorderRadius),
                      ),
                      child: Image.asset(
                        'assets/icons/folder.png',
                        color: Color(0xff2696FE),
                        width: smallIconSize,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ButtonWrapper(
                  onTap: () {
                    //? creating a new folder to the current active folder
                  },
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad,
                    vertical: kVPad,
                  ),
                  child: Image.asset(
                    'assets/icons/plus.png',
                    width: largeIconSize / 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            HLine(
              thickness: 1,
              color: kInactiveColor.withOpacity(.1),
            ),
            VSpace(factor: .5),
            PaddingWrapper(
                child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                currenActiveDir.path,
                style: h4TextStyleInactive,
              ),
            )),
            VSpace(factor: .5),
            HLine(
              thickness: 1,
              color: kInactiveColor.withOpacity(.1),
            ),
            VSpace(factor: .5),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  ...ScanningUtils()
                      .getDirectFolderChildern(
                        Directory(currenActiveDir.path),
                      )
                      .map(
                        (e) => StorageItem(
                          fileSystemEntity: e,
                          onDirTapped: clickFolder,
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
