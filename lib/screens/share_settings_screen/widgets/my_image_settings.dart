// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class MyImageSettings extends StatelessWidget {
  const MyImageSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);

    return Container(
      padding: shareProvider.myImagePath == null
          ? EdgeInsets.all(largePadding * 1.5)
          : null,
      clipBehavior: Clip.hardEdge,
      width: largeIconSize * 3,
      height: largeIconSize * 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.2),
      ),
      child: shareProvider.myImagePath == null
          ? Image.asset(
              'assets/icons/user.png',
              color: kCardBackgroundColor.withOpacity(1),
            )
          : Image.file(
              File(shareProvider.myImagePath!),
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }
}
