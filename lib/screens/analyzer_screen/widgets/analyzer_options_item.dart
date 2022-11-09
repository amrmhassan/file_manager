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

  const AnalyzerOptionsItem({
    Key? key,
    required this.onTap,
    required this.title,
    required this.logoName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
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
              'assets/icons/$logoName.png',
              width: mediumIconSize,
            ),
            HSpace(),
            Text(
              title,
              style: h3TextStyle.copyWith(
                color: Colors.white.withOpacity(.6),
              ),
            ),
            Spacer(),
            Image.asset(
              'assets/icons/right-arrow.png',
              width: mediumIconSize,
              color: Colors.white.withOpacity(.6),
            )
          ],
        ),
      ),
    );
  }
}
