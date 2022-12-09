// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class RecentItemType extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;
  final String title;
  final Color color;

  const RecentItemType({
    Key? key,
    required this.iconName,
    required this.onTap,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      alignment: Alignment.center,
      width: 80,
      height: 80,
      borderRadius: 0,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(largePadding),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(500),
            ),
            child: Image.asset(
              'assets/icons/recent/$iconName.png',
              width: mediumIconSize,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
