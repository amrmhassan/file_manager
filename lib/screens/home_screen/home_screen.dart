// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:async';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:explorer/utils/general_utils.dart';

final Directory initialDir = Directory('sdcard');

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeViewIndex = 1;
  void setActiveScreen(int i) {
    pageController.animateToPage(
      i,
      duration: homePageViewDuration,
      curve: Curves.easeInOut,
    );
    setState(() {
      activeViewIndex = i;
    });
  }

  late PageController pageController;
  Directory currentActiveDir = initialDir;
  int exitCounter = 0;
  List<FileSystemEntity> viewedChildren = [];
  String? error;
  bool loading = false;
  StreamSubscription<FileSystemEntity>? streamSub;

  //? update viewed children
  void updateViewChildren(String path) async {
    try {
      if (streamSub != null) {
        await streamSub!.cancel();
      }
      Stream<FileSystemEntity> chidrenStream = currentActiveDir.list();
      setState(() {
        error = null;
        loading = true;
        viewedChildren.clear();
      });

      streamSub = chidrenStream.listen((entity) {
        setState(() {
          viewedChildren.add(entity);
        });
      });
      streamSub!.onError((e, s) {
        setState(() {
          error = e.toString();
        });
      });
      streamSub!.onDone(() {
        setState(() {
          loading = false;
        });
      });
    } catch (e, s) {
      printOnDebug(e);
      printOnDebug(s);
      setState(() {
        viewedChildren.clear();
        error = e.toString();
      });
    }
  }

  //? this will handle what happen when clicking a folder
  void updateActivePath(String path) {
    setState(() {
      currentActiveDir = Directory(path);
    });
    updateViewChildren(currentActiveDir.path);
  }

//? handling going back in path
  void goBack() {
    if (currentActiveDir.parent.path == '.') return;
    updateActivePath(currentActiveDir.parent.path);
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

  Future<void> handleStoragePermissions() async {
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
      } else {
        updateViewChildren(currentActiveDir.path);
      }
    } else {
      updateViewChildren(currentActiveDir.path);
    }
  }

  //? go home
  void goHome() {
    updateActivePath(initialDir.path);
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: activeViewIndex,
    );
    //? getting storage permission
    Future.delayed(Duration.zero).then((value) async {
      Provider.of<ChildrenItemsProvider>(context, listen: false)
          .getAndUpdataAllSavedFolders();
      handleStoragePermissions();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var childrenToPassToList = showHiddenFiles
        ? viewedChildren
        : viewedChildren.where(
            (element) {
              return !path.basename(element.path).startsWith('.');
            },
          ).toList();
    return WillPopScope(
      onWillPop: handlePressPhoneBackButton,
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            HomeAppBar(
              goBack: goBack,
              loadingFolder: loading,
              activeScreenIndex: activeViewIndex,
              setActiveScreen: setActiveScreen,
            ),
            Expanded(
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    activeViewIndex = value;
                  });
                },
                controller: pageController,
                physics: BouncingScrollPhysics(),
                children: [
                  AnalyzerScreen(),
                  ExplorerScreen(
                    clickFolder: updateActivePath,
                    viewedChildren: childrenToPassToList,
                    error: error,
                    loading: loading,
                    activeDirectory: currentActiveDir,
                    currentActiveDir: currentActiveDir,
                    goHome: goHome,
                    childrenToPassToList: childrenToPassToList,
                    updateActivePath: updateActivePath,
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
