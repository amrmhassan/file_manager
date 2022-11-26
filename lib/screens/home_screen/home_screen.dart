// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';
import 'dart:isolate';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:explorer/screens/explorer_screen/explorer_screen.dart';
import 'package:explorer/screens/home_screen/utils/permissions.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';

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

  @override
  void initState() {
    pageController = PageController(
      initialPage: activeViewIndex,
    );
    Future.delayed(Duration.zero).then((value) async {
      await Provider.of<ExplorerProvider>(context, listen: false)
          .loadSortOptions();
      await Provider.of<AnalyzerProvider>(context, listen: false)
          .loadInitialAppData();

      //* getting storage permission
      bool res = await showPermissionsModal(
        context: context,
        callback: () => handlePermissionsGrantedCallback(context),
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
        scfKey: expScreenKey,
        drawer: Container(
          color: kBackgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: kBackgroundColor,
                width: Responsive.getWidthPercentage(context, .75),
                child: Text(
                  'This will be the app drawer',
                  style: h4TextStyleInactive,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: kBackgroundColor,
        child: Stack(
          children: [
            Column(
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
            if (kDebugMode)
              GestureDetector(
                onTap: () async {
                  await DBHelper.clearDb();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
              )
          ],
        ),
      ),
    );
  }
}
