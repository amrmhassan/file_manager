// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? title;
  final Widget? rightIcon;
  final Widget? leftIcon;

  const CustomAppBar({
    super.key,
    this.title,
    this.rightIcon,
    this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: kAppBarHeight,
              child: Row(
                children: [
                  //! left icon will be here
                  if (leftIcon != null) leftIcon!,
                  Spacer(),
                  //! right icon will be here
                  if (rightIcon != null) rightIcon!,
                ],
              ),
            ),
            //! title will be here
            if (title != null) title!,
          ],
        ),
        HLine(
          thickness: 1,
          color: kCardBackgroundColor,
        ),
      ],
    );
  }
}
