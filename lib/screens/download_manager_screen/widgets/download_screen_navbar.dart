// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_tab_button.dart';
import 'package:flutter/material.dart';

class DownloadScreenNavBar extends StatelessWidget {
  final int activeTab;
  final Function(int i) setActiveTab;
  const DownloadScreenNavBar({
    super.key,
    required this.activeTab,
    required this.setActiveTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        right: kHPad * 1.5,
        left: kHPad * 1.5,
        top: kVPad / 2,
        bottom: kVPad / 2,
      ),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(largeBorderRadius),
          topRight: Radius.circular(largeBorderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DownloadTabButton(
            activeTab: activeTab,
            iconName: 'download-circular-button',
            myIndex: 0,
            onTap: () => setActiveTab(0),
            title: 'Active',
          ),
          DownloadTabButton(
            activeTab: activeTab,
            iconName: 'accept',
            myIndex: 1,
            onTap: () => setActiveTab(1),
            title: 'Done',
          ),
          DownloadTabButton(
            activeTab: activeTab,
            iconName: 'error',
            myIndex: 2,
            onTap: () => setActiveTab(2),
            title: 'Error',
          ),
        ],
      ),
    );
  }
}
