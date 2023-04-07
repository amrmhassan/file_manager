// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class NewVersionScreen extends StatelessWidget {
  static const String routeName = '/NewVersionScreen';
  const NewVersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Image.asset(
            'assets/icons/screen.png',
            width: Responsive.getWidth(context) / 1.5,
          ),
          VSpace(factor: 2),
          Text(
            'Windows To Windows Share',
            style: h2TextStyle,
          ),
          VSpace(),
          PaddingWrapper(
            child: Text(
              'Share seamlessly across Windows and Android devices.',
              style: h3InactiveTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
          VSpace(factor: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWrapper(
                padding: EdgeInsets.symmetric(
                  horizontal: kHPad,
                  vertical: kVPad / 2,
                ),
                onTap: () {},
                backgroundColor: kCardBackgroundColor,
                child: Text(
                  'Download Now',
                  style: h3LightTextStyle,
                ),
              ),
            ],
          ),
          Text(
            'Download Windows Version Now',
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
