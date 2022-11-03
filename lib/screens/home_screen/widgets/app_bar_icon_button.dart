// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconName;
  final Color? color;
  final double borderRadius;

  const AppBarIconButton({
    Key? key,
    required this.onTap,
    required this.iconName,
    this.color,
    this.borderRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      borderRadius: borderRadius,
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad,
      ),
      child: Image.asset(
        'assets/icons/$iconName.png',
        width: largeIconSize / 2,
        color: color ?? kInactiveColor,
      ),
    );
  }
}
