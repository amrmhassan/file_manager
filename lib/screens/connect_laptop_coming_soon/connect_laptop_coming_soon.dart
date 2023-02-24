// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class ConnLaptopComingSoon extends StatelessWidget {
  static const String routeName = '/ConnLaptopComingSoon';
  const ConnLaptopComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: SizedBox(
        height: Responsive.getHeight(context),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            CustomAppBar(
              title: Text(
                'Laptop (Windows)',
                style: h2liteTextStyle,
              ),
            ),
            VSpace(factor: 2),
            Image.asset(
              'assets/icons/connection.png',
              width: largeIconSize * 4,
            ),
            VSpace(factor: 2),
            PaddingWrapper(
              child: Text(
                'We are working on update that will allow you to fully control your windows device from your phone and vice versa',
                style: h4TextStyleInactive,
                textAlign: TextAlign.center,
              ),
            ),
            VSpace(),
            PaddingWrapper(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: double.infinity),
                    Text('Features:', style: h3TextStyle),
                    VSpace(),
                    Text('1- Remote files explorer', style: h4TextStyle),
                    Text('2- Share space explorer', style: h4TextStyle),
                    Text('3- Clipboard control', style: h4TextStyle),
                    Text('4- Sending files', style: h4TextStyle),
                    Text('5- Sending text messages', style: h4TextStyle),
                    Text(
                        '6- Viewing video, audio without downloading on mobile',
                        style: h4TextStyle),
                    VSpace(),
                    HLine(
                      thickness: 1,
                      color: kMainIconColor.withOpacity(.5),
                    ),
                    Text(
                      'You can do this from phone to windows or vice versa 😎',
                      style: h3TextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Text(
              'Stay Tuned ❤',
              style: h2TextStyle,
            ),
            VSpace(),
          ],
        ),
      ),
    );
  }
}
