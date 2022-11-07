// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class AppBarSwitcherButton extends StatelessWidget {
  final Widget child;
  final bool active;
  final VoidCallback onTap;

  const AppBarSwitcherButton({
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
