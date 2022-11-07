// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class AnalyzerScreen extends StatelessWidget {
  const AnalyzerScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWrapper(
                  padding: EdgeInsets.symmetric(
                      horizontal: kHPad / 2, vertical: kVPad / 3),
                  onTap: () {},
                  border: Border.all(color: kInactiveColor),
                  borderRadius: 1000,
                  child: Text(
                    'Start Analyze',
                    style: h4TextStyleInactive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
