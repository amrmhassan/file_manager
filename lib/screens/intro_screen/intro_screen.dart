// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
          Colors.white.withOpacity(.4),
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
            'Done',
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
            'Skip',
            style: h4LiteTextStyle,
          )),
      pages: [
        PageViewModel(
          reverse: true,
          titleWidget: Column(
            children: [
              VSpace(factor: 3),
              Text(
                'Connect Windows',
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            'Gain full control over your windows device and vice versa',
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
                'Share Space',
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            'Now you can add files to share space to let others view them',
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
          title: 'Streaming',
          bodyWidget: Text(
            'Video, Audios from share space can be viewed without downloaded',
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
                'Quick Send',
                style: h1TextStyle,
              ),
            ],
          ),
          bodyWidget: Text(
            'You can send files to others just by their browsers.\nNo need for the app on the other device',
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
          title: 'Advanced Explorer',
          bodyWidget: Text(
            'Enjoy million features with exploring your files',
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
        PageViewModel(
          title: 'Storage Analyzer',
          bodyWidget: Text(
            'Maximize your storage space with ease using our advanced storage analyzer tools',
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
