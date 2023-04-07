// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:localization/localization.dart';

class IntroScreen extends StatelessWidget {
  static const String routeName = '/intro_screen';
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: kMainIconColor,
        colors: [
          Colors.white.withOpacity(.4),
          Colors.white.withOpacity(.4),
          Colors.white.withOpacity(.4),
          Colors.white.withOpacity(.4),
          Colors.white.withOpacity(.4),
          if (Platform.isAndroid) Colors.white.withOpacity(.4),
        ],
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      globalBackgroundColor: kBackgroundColor,
      showNextButton: false,
      showSkipButton: true,
      showDoneButton: true,
      overrideDone: ButtonWrapper(
          padding: EdgeInsets.symmetric(
            horizontal: kHPad,
            vertical: kVPad / 2,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
          child: Text(
            'done'.i18n(),
            style: h4LiteTextStyle,
          )),
      overrideSkip: ButtonWrapper(
          padding: EdgeInsets.symmetric(
            horizontal: kHPad,
            vertical: kVPad / 2,
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
          child: Text(
            'skip'.i18n(),
            style: h4LiteTextStyle,
          )),
      pages: [
        PageViewModel(
          reverse: true,
          titleWidget: Column(
            children: [
              VSpace(factor: 3),
              Text(
                Platform.isAndroid
                    ? 'connect-windows-intro'.i18n()
                    : 'connect-android-intro'.i18n(),
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            Platform.isAndroid
                ? 'connect-windows-intro-note'.i18n()
                : 'connect-android-intro-note'.i18n(),
            style: h3InactiveTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Column(
            children: [
              VSpace(factor: 2),
              Image.asset(
                'assets/icons/connection.png',
                width: Responsive.getWidthPercentage(context, .5),
              ),
            ],
          ),
        ),
        PageViewModel(
          reverse: true,
          titleWidget: Column(
            children: [
              VSpace(factor: 3),
              Text(
                'share-space-intro'.i18n(),
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            'share-space-intro-note'.i18n(),
            style: h3InactiveTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Column(
            children: [
              VSpace(factor: 2),
              Image.asset(
                'assets/icons/intro/disruption.png',
                width: Responsive.getWidthPercentage(context, .5),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: 'streaming-intro'.i18n(),
          bodyWidget: Text(
            'streaming-intro-note'.i18n(),
            style: h3InactiveTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Column(
            children: [
              VSpace(factor: 3),
              Image.asset(
                'assets/icons/intro/live-streaming.png',
                width: Responsive.getWidthPercentage(context, .5),
              ),
            ],
          ),
        ),
        PageViewModel(
          reverse: true,
          titleWidget: Column(
            children: [
              VSpace(factor: 3),
              Text(
                'quick-send-intro'.i18n(),
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            'quick-send-intro-note'.i18n(),
            style: h3InactiveTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Column(
            children: [
              VSpace(factor: 2),
              Image.asset(
                'assets/icons/intro/content-management.png',
                width: Responsive.getWidthPercentage(context, .5),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: 'advanced-explorer-intro'.i18n(),
          bodyWidget: Text(
            'advanced-explorer-intro-note'.i18n(),
            style: h3InactiveTextStyle,
            textAlign: TextAlign.center,
          ),
          image: Column(
            children: [
              VSpace(factor: 3),
              Image.asset(
                'assets/icons/intro/adventurer.png',
                width: Responsive.getWidthPercentage(context, .5),
              ),
            ],
          ),
        ),
        if (Platform.isAndroid)
          PageViewModel(
            title: 'storage-analyzer-text'.i18n(),
            bodyWidget: Text(
              'storage-analyzer-intro-note'.i18n(),
              style: h3InactiveTextStyle,
              textAlign: TextAlign.center,
            ),
            image: Column(
              children: [
                VSpace(factor: 3),
                Image.asset(
                  'assets/icons/intro/analyzing.png',
                  width: Responsive.getWidthPercentage(context, .5),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
