// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

class ScanningStorageScreen extends StatelessWidget {
  static const String routeName = '/ScanningStorageScreen';
  const ScanningStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Center(
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Analyze Storage'),
          ),
        ));
  }
}
