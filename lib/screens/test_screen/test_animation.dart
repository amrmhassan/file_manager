// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:flutter/material.dart';

class TestingAnimation extends StatefulWidget {
  const TestingAnimation({
    Key? key,
  }) : super(key: key);

  @override
  State<TestingAnimation> createState() => _TestingAnimationState();
}

class _TestingAnimationState extends State<TestingAnimation> {
  GlobalKey<AnimatedListState> bb = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
      child: Container(
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(mediumBorderRadius),
        ),
        width: double.infinity,
        height: 50,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                widthFactor: .5,
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  color: Colors.red,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: AnimatedFractionallySizedBox(
                widthFactor: .5,
                duration: Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
