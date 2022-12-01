// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/analyzer_screen/analyzer_screen.dart';
import 'package:flutter/material.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Container(
        color: kBackgroundColor,
        width: Responsive.getWidthPercentage(context, .75),
        height: double.infinity,
        child: Column(
          children: [
            VSpace(factor: 4),
            Image.asset(
              'assets/icons/logo.png',
              width: largeIconSize * 3,
            ),
            VSpace(factor: 2),
            ButtonWrapper(
              borderRadius: 0,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AnalyzerScreen.routeName);
              },
              child: ListTile(
                leading: Image.asset(
                  'assets/icons/analyze.png',
                  width: mediumIconSize,
                  color: kInactiveColor,
                ),
                title: Text(
                  'Storage Analyzer',
                  style: h4TextStyle.copyWith(color: kInactiveColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}