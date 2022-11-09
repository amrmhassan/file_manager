// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'dart:async';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:explorer/screens/home_screen/utils/permissions.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:explorer/utils/general_utils.dart';

class HomeScreen extends StatefulWidget {
  final bool sizesExplorer;
  static const String routeName = '/home-screen';

  const HomeScreen({
    super.key,
    this.sizesExplorer = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeViewIndex = 1;
  late PageController pageController;
  Directory currentActiveDir = initialDir;
  int exitCounter = 0;
  List<StorageItemModel> viewedChildren = [];
  String? error;
  bool loadingDirDirectChildren = false;
  StreamSubscription<FileSystemEntity>? streamSub;

//? set the current acitive screen
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

  //? update viewed children
  void updateViewChildren(String path) async {
    try {
      if (streamSub != null) {
        await streamSub!.cancel();
      }
      Stream<FileSystemEntity> chidrenStream = currentActiveDir.list();
      setState(() {
        error = null;
        loadingDirDirectChildren = true;
        viewedChildren.clear();
      });

      streamSub = chidrenStream.listen((entity) async {
        FileStat fileStat = entity.statSync();
        StorageItemModel storageItemModel = StorageItemModel(
          parentPath: entity.parent.path,
          path: entity.path,
          modified: fileStat.modified,
          accessed: fileStat.accessed,
          changed: fileStat.changed,
          entityType: fileStat.type == FileSystemEntityType.directory
              ? EntityType.folder
              : EntityType.file,
          size: fileStat.type == FileSystemEntityType.directory
              ? null
              : fileStat.size,
        );
        setState(() {
          viewedChildren.add(storageItemModel);
        });
      });
      streamSub!.onError((e, s) {
        setState(() {
          error = e.toString();
        });
      });
      streamSub!.onDone(() {
        setState(() {
          loadingDirDirectChildren = false;
        });
      });
    } catch (e) {
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
      if (widget.sizesExplorer) {
        return Future.delayed(Duration.zero).then((value) => true);
      }
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

  //? go home
  void goHome() {
    updateActivePath(initialDir.path);
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: activeViewIndex,
    );
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<AnalyzerProvider>(context, listen: false)
          .loadInitialAppData();
      //* getting storage permission
      bool res = await handleStoragePermissions(
        context: context,
        currentActiveDir: currentActiveDir,
        updateViewChildren: updateActivePath,
      );
      if (!res) return;
      await Provider.of<ChildrenItemsProvider>(context, listen: false)
          .getAndUpdataAllSavedFolders();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handlePressPhoneBackButton,
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            HomeAppBar(
              goBack: goBack,
              loadingFolder: loadingDirDirectChildren,
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
                physics: widget.sizesExplorer
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                children: [
                  AnalyzerScreen(),
                  ExplorerScreen(
                    clickFolder: updateActivePath,
                    viewedChildren: viewedChildren,
                    error: error,
                    loading: loadingDirDirectChildren,
                    activeDirectory: currentActiveDir,
                    currentActiveDir: currentActiveDir,
                    goHome: goHome,
                    sizesExplorer: widget.sizesExplorer,
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
