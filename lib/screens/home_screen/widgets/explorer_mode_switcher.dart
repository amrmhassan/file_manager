// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_switcher_button.dart';
import 'package:flutter/material.dart';

class ExplorerModeSwitcher extends StatelessWidget {
  final int activeScreenIndex;
  final Function(int index) setActiveScreen;
  const ExplorerModeSwitcher({
    Key? key,
    required this.activeScreenIndex,
    required this.setActiveScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBarSwitcherButton(
                active: activeScreenIndex == 0,
                child: Image.asset(
                  'assets/icons/chart.png',
                  width: smallIconSize,
                ),
                onTap: () => setActiveScreen(0),
              ),
              AppBarSwitcherButton(
                child: Image.asset(
                  'assets/icons/folder.png',
                  color: Color(0xff2696FE),
                  width: smallIconSize,
                ),
                active: activeScreenIndex == 1,
                onTap: () => setActiveScreen(1),
              )
            ],
          ),
        ),
      ],
    );
  }
}
