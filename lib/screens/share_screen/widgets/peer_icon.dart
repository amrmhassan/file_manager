// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PeerIcon extends StatelessWidget {
  final bool large;
  final String? imagePath;

  const PeerIcon({
    Key? key,
    this.large = false,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: imagePath == null ? EdgeInsets.all(largePadding * 1.5) : null,
      clipBehavior: Clip.hardEdge,
      width: large ? largeIconSize * 3 : 60,
      height: large ? largeIconSize * 3 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.2),
      ),
      child: imagePath == null
          ? Image.asset(
              'assets/icons/user.png',
              color: kCardBackgroundColor.withOpacity(1),
            )
          : Image.file(
              File(imagePath!),
              alignment: Alignment.topCenter,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
    );
  }
}
