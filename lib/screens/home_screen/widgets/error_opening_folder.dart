// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class ErrorOpenFolder extends StatelessWidget {
  const ErrorOpenFolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/warning.png',
          width: largeIconSize * 2,
        ),
        VSpace(factor: .5),
        Text(
          'Your Android System Prevent Viewing This Folder',
          style: h4TextStyleInactive.copyWith(
            color: kInactiveColor,
          ),
        ),
      ],
    );
  }
}
