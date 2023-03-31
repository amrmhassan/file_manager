// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';
import 'dart:isolate';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/custom_app_drawer/custom_app_drawer.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';

import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';

//* this is the home page controller
PageController pageController = PageController();

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home-screen';
  final bool fileViewer;

  const HomeScreen({
    super.key,
    this.fileViewer = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int exitCounter = 0;
  SendPort? globalSendPort;

  @override
  void initState() {
    pageController = PageController(
      initialPage: expPF(context).activeViewIndex,
    );
    initHomeScreen(context);

    super.initState();
  }

  bool get withPopScope {
    if (Platform.isAndroid) {
      var mpProvider = mpP(context);
      return !mpProvider.videoHidden &&
          mpProvider.videoPlayerController != null;
    } else {
      var mpProvider = WindowSProviders.mpP(context);
      return !mpProvider.videoHidden &&
          mpProvider.videoPlayerController != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = expP(context);

    var homeScreenContent = ScreensWrapper(
      scfKey: expScreenKey,
      drawer: CustomAppDrawer(),
      backgroundColor: kBackgroundColor,
      child: Stack(
        children: [
          Column(
            children: [
              HomeAppBar(
                activeScreenIndex: expProvider.activeViewIndex,
                setActiveScreen: (index) => setActiveScreen(context, index),
                sizesExplorer: false,
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    expPF(context).setActivePageIndex(value);
                  },
                  controller: pageController,
                  physics: BouncingScrollPhysics(),
                  children: [
                    RecentScreen(),
                    ExplorerScreen(
                      sizesExplorer: false,
                      viewFile: widget.fileViewer,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // error red widget that opens the errors logging screen
        ],
      ),
    );
    return withPopScope
        ? homeScreenContent
        : WillPopScope(
            onWillPop: () => handlePressPhoneBackButton(
              context: context,
              exitCounter: exitCounter,
              sizesExplorer: false,
              clearExitCounter: () {
                exitCounter = 0;
              },
              incrementExitCounter: () {
                exitCounter++;
              },
            ),
            child: homeScreenContent,
          );
  }
}
