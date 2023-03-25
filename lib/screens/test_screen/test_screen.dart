// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [],
        ));
  }
}
