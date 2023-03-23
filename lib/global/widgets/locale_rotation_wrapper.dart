// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:explorer/utils/global_utils.dart';
import 'package:flutter/material.dart';

class LocaleRotationWrapper extends StatelessWidget {
  final Widget child;
  const LocaleRotationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(CustomLocale.isArabic(context) ? pi : 0),
      child: child,
    );
  }
}
