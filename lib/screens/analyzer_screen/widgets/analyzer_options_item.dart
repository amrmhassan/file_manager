// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:flutter/material.dart';

class AnalyzerOptionsItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String logoName;
  final Color? color;
  final String? iconPath;
  final bool enablePadding;

  const AnalyzerOptionsItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.logoName,
    this.color,
    this.iconPath,
    this.enablePadding = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
      padding: enablePadding ? null : EdgeInsets.zero,
      child: ButtonWrapper(
        onTap: onTap,
        padding:
            EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(
            mediumBorderRadius,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath ?? 'assets/icons/$logoName.png',
              width: mediumIconSize,
              color: color,
            ),
            HSpace(),
            Text(
              title,
              style: h3TextStyle.copyWith(
                color: kInActiveTextColor,
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/icons/right-arrow.png',
              width: mediumIconSize,
              color: kMainIconColor,
            )
          ],
        ),
      ),
    );
  }
}
