// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentPathViewer extends StatelessWidget {
  const CurrentPathViewer({
    Key? key,
    required this.currentActiveDir,
  }) : super(key: key);

  final Directory currentActiveDir;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: currentActiveDir.path));
        showSnackBar(context: context, message: 'Copied To Clipboard');
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
        color: kCardBackgroundColor,
        alignment: Alignment.centerLeft,
        child: Text(
          currentActiveDir.path,
          style: h4TextStyleInactive,
        ),
      ),
    );
  }
}
