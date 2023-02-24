// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/screens/download_manager_screen/widgets/active_screen.dart';
import 'package:explorer/screens/download_manager_screen/widgets/done_screen.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_error_screen.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_screen_navbar.dart';
import 'package:explorer/screens/download_settings_screen/download_settings_screen.dart';
import 'package:flutter/material.dart';

class DownloadManagerScreen extends StatefulWidget {
  static const String routeName = '/DownloadManagerScreen';
  const DownloadManagerScreen({super.key});

  @override
  State<DownloadManagerScreen> createState() => _DownloadManagerScreenState();
}

class _DownloadManagerScreenState extends State<DownloadManagerScreen> {
  late PageController pageController;
  int activeTab = 0;

  void setActiveTab(int i, [bool animate = true]) {
    if (animate) {
      pageController.animateToPage(
        i,
        duration: homePageViewDuration,
        curve: Curves.easeInOut,
      );
    }
    setState(() {
      activeTab = i;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: activeTab);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Download Manager',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            rightIcon: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWrapper(
                      onTap: () {
                        Navigator.pushNamed(
                            context, DownloadSetScreen.routeName);
                      },
                      child: Image.asset(
                        'assets/icons/settings.png',
                        width: smallIconSize,
                        color: kMainIconColor,
                      ),
                      padding: EdgeInsets.all(largePadding),
                    ),
                  ],
                ),
                HSpace(factor: .5),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: BouncingScrollPhysics(),
              onPageChanged: (value) => setActiveTab(value, false),
              controller: pageController,
              children: [
                ActiveScreen(),
                DoneScreen(),
                DownloadErrorScreen(),
              ],
            ),
          ),
          DownloadScreenNavBar(
            activeTab: activeTab,
            setActiveTab: setActiveTab,
          ),
        ],
      ),
    );
  }
}
