// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:flutter/material.dart';

class StatusItem extends StatelessWidget {
  final String iconName;
  final String title;
  final VoidCallback onTap;

  const StatusItem({
    Key? key,
    required this.iconName,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonWrapper(
        onTap: onTap,
        padding: EdgeInsets.symmetric(
          horizontal: kHPad / 2,
          vertical: kVPad / 2,
        ),
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(
            mediumBorderRadius,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/whatsapp/w-$iconName.png',
              width: mediumIconSize,
            ),
            HSpace(factor: .8),
            Text(
              title,
              style: h4LightTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
