// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class RecentItemType extends StatelessWidget {
  final String iconName;
  final VoidCallback onTap;
  final String title;

  const RecentItemType({
    Key? key,
    required this.iconName,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      alignment: Alignment.center,
      width: 80,
      height: 80,
      borderRadius: 0,
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/$iconName.png',
            width: largeIconSize,
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
