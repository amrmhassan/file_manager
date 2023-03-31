// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import './video_fast_seeker.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class BaseOverLay extends StatelessWidget {
  // this will be clicked when no other element is being clicked
  final VoidCallback toggleControllerOverLayViewed;
  final int backwardActualAmount;
  final bool backwardShown;

  final int forwardActualAmount;
  final bool forwardShown;
  const BaseOverLay({
    super.key,
    required this.toggleControllerOverLayViewed,
    required this.backwardActualAmount,
    required this.backwardShown,
    required this.forwardActualAmount,
    required this.forwardShown,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () {
                toggleControllerOverLayViewed();
              },
              child: Opacity(
                opacity: 1,
                child: Container(
                  height: Responsive.getHeight(context) - largeIconSize * 1.5,
                  width: Responsive.getWidth(context),
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
        VideoFastSeeker(
          actualAmount: backwardActualAmount,
          backward: true,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
          shown: backwardShown,
        ),
        VideoFastSeeker(
          backward: false,
          toggleControllerOverLayViewed: toggleControllerOverLayViewed,
          actualAmount: forwardActualAmount,
          shown: forwardShown,
        ),
      ],
    );
  }
}
