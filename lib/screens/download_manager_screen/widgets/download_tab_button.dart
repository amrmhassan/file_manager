// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class DownloadTabButton extends StatelessWidget {
  final int activeTab;
  final int myIndex;
  final VoidCallback onTap;
  final String iconName;
  final String title;

  const DownloadTabButton({
    super.key,
    required this.activeTab,
    required this.myIndex,
    required this.onTap,
    required this.iconName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      padding: EdgeInsets.symmetric(vertical: kVPad / 6),
      backgroundColor: activeTab == myIndex ? kBackgroundColor : null,
      onTap: onTap,
      width: largeIconSize * 2,
      alignment: Alignment.center,
      child: Column(
        children: [
          Image.asset(
            'assets/icons/$iconName.png',
            width: mediumIconSize,
            color: kMainIconColor.withOpacity(.5),
          ),
          VSpace(factor: .2),
          Text(
            title,
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
