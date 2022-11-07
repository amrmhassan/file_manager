// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
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
        HeaderActiveScreen(
          active: activeScreenIndex == 0,
          child: Image.asset(
            'assets/icons/chart.png',
            width: smallIconSize,
          ),
          onTap: () => setActiveScreen(0),
        ),
        HeaderActiveScreen(
          child: Image.asset(
            'assets/icons/folder.png',
            color: Color(0xff2696FE),
            width: smallIconSize,
          ),
          active: activeScreenIndex == 1,
          onTap: () => setActiveScreen(1),
        )
      ],
    );
  }
}

class HeaderActiveScreen extends StatelessWidget {
  final Widget child;
  final bool active;
  final VoidCallback onTap;

  const HeaderActiveScreen({
    Key? key,
    required this.child,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kHPad,
          vertical: kVPad / 2,
        ),
        decoration: BoxDecoration(
          color: active ? kLightCardBackgroundColor : kCardBackgroundColor,
          borderRadius: BorderRadius.circular(smallBorderRadius),
        ),
        child: child,
      ),
    );
  }
}
