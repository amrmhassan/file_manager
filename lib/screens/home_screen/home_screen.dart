// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';
import 'dart:isolate';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:explorer/screens/home_screen/utils/permissions.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:explorer/utils/general_utils.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeViewIndex = 1;
  late PageController pageController;
  int exitCounter = 0;
  SendPort? globalSendPort;

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

  // void runTheIsolate() {
  //   var receivePort = ReceivePort();
  //   var sendPort = receivePort.sendPort;
  //   Isolate.spawn(loadExplorerChildren, sendPort);
  //   receivePort.listen((message) {
  //     if (message is SendPort) {
  //       globalSendPort = message;
  //     } else if (message is LoadChildrenMessagesData) {
  //       if (message.flag == LoadChildrenMessagesFlags.childrenChunck) {
  //         setState(() {
  //           viewedChildren.addAll(message.data);
  //         });
  //       } else if (message.flag == LoadChildrenMessagesFlags.done) {
  //         setState(() {
  //           viewedChildren.addAll(message.data);
  //           loadingDirDirectChildren = false;
  //         });
  //       } else if (message.flag == LoadChildrenMessagesFlags.error) {
  //         setState(() {
  //           error = error.toString();
  //         });
  //       }
  //     }
  //   });
  // }

//? update viewed children
  // void updateViewChildren(String path) async {
  //   setState(() {
  //     error = null;
  //     loadingDirDirectChildren = true;
  //     viewedChildren.clear();
  //   });
  //   if (globalSendPort != null) {
  //     globalSendPort!.send(path);
  //   }
  // }

  //? update viewed children
  // void updateViewChildren(String path) async {
  //   Provider.of<ExplorerProvider>(context, listen: false)
  //       .setActiveDir(path: path);
  // }

//? handling going back in path

  @override
  void initState() {
    // runTheIsolate();
    pageController = PageController(
      initialPage: activeViewIndex,
    );
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<AnalyzerProvider>(context, listen: false)
          .loadInitialAppData();
      var expProvider = Provider.of<ExplorerProvider>(context, listen: false);
      //* getting storage permission
      bool res = await handleStoragePermissions(
        context: context,
        callback: () {
          expProvider.setActiveDir(path: expProvider.currentActiveDir.path);
        },
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
      onWillPop: () => handlePressPhoneBackButton(
        context: context,
        exitCounter: exitCounter,
        sizesExplorer: false,
        clearExitCounter: () {
          exitCounter = 0;
        },
        incrmentExitCounter: () {
          exitCounter++;
        },
      ),
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            HomeAppBar(
              activeScreenIndex: activeViewIndex,
              setActiveScreen: setActiveScreen,
              sizesExplorer: false,
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
                    sizesExplorer: false,
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
