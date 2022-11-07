// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class EmptyFolder extends StatelessWidget {
  const EmptyFolder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/empty1.png',
          width: largeIconSize * 2,
        ),
        VSpace(factor: .5),
        Text(
          'This Folder Is Empty',
          style: h4TextStyleInactive.copyWith(
            color: kInActiveTextColor,
          ),
        ),
      ],
    );
  }
}
