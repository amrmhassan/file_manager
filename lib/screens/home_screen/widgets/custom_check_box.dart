// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.checked,
    this.onTap,
  }) : super(key: key);

  final bool? checked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(smallPadding),
        width: smallIconSize,
        height: smallIconSize,
        decoration: BoxDecoration(
          color: checked! ? kBlueColor : null,
          borderRadius: BorderRadius.circular(smallBorderRadius),
          border: checked!
              ? null
              : Border.all(
                  color: kInactiveColor,
                  width: 2,
                ),
        ),
        child: checked!
            ? Image.asset(
                'assets/icons/check.png',
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
