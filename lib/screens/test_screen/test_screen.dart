// ignore_for_file: prefer_const_constructors

import 'dart:isolate';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double height = 20;
  bool touched = false;
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              height: height,
              color: Colors.red,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onPanDown: (details) {
                setState(() {
                  touched = true;
                });
              },
              onPanCancel: () {
                setState(() {
                  touched = false;
                });
              },
              onPanEnd: (d) {
                setState(() {
                  touched = false;
                });
              },
              onPanUpdate: (details) {
                // Swiping in right direction.
                if (details.delta.dx > 0) {
                  setState(() {
                    height = details.delta.direction.isNegative
                        ? height + details.delta.distance
                        : height - details.delta.distance;
                  });
                }

                // Swiping in left direction.
                if (details.delta.dx < 0) {}
              },
              child: Container(
                height: double.infinity,
                color: touched ? Colors.black : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
