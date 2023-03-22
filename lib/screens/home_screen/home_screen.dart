// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';
import 'dart:isolate';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/custom_app_drawer/custom_app_drawer.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:explorer/providers/recent_provider.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:explorer/screens/home_screen/utils/permissions.dart';
import 'package:explorer/screens/recent_screen/recent_screen.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';

import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/children_info_provider.dart';
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
      initialPage:
          Provider.of<ExplorerProvider>(context, listen: false).activeViewIndex,
    );
    Future.delayed(Duration.zero).then((value) async {
      var recentProvider = Provider.of<RecentProvider>(context, listen: false);
      await expPF(context).loadSortOptions();
      //?
      await analyzerPF(context).loadInitialAppData(recentProvider);
      //?
      await listyPF(context).loadListyLists();
      //?
      await sharePF(context).loadSharedItems();
      //?
      await sharePF(context).loadDeviceIdAndName();
      //?
      await downPF(context).loadDownloadSettings();
      //?
      await downPF(context).loadTasks();
      //?
      mpPF(context).handlePlayingAudioAfterResumingApp();
      //?
      await recentPF(context).loadFoldersToWatchThenListen();

      //* getting storage permission
      bool res = await showPermissionsModal(
        context: context,
        callback: () => handlePermissionsGrantedCallback(context),
      );
      if (!res) {
        SystemNavigator.pop();
        return;
      }

      await Provider.of<ChildrenItemsProvider>(context, listen: false)
          .getAndUpdateAllSavedFolders();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

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
                    Provider.of<ExplorerProvider>(context, listen: false)
                        .setActivePageIndex(value);
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
    return !mpProvider.videoHidden && mpProvider.videoPlayerController != null
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
