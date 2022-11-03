// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class ExplorerModeSwitcher extends StatelessWidget {
  const ExplorerModeSwitcher({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
