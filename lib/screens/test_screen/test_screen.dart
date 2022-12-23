// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

PageController pageController = PageController();

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ScrollController scrollController = ScrollController();
  double _height = 0;

  void addToHeight(double deltaY) {
    double newHeight = _height + deltaY;
    if (newHeight > Responsive.getHeight(context)) {
      newHeight = Responsive.getHeight(context);
    } else if (newHeight < 0) {
      newHeight = 0;
    }
    setState(() {
      _height = newHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                color: Colors.red,
                height: _height,
                width: Responsive.getWidth(context) / 2,
              ),
              Listener(
                onPointerMove: (event) {
                  addToHeight(-event.delta.dy);
                },
                child: Container(
                  color: Colors.blue,
                  height: double.infinity,
                  width: Responsive.getWidth(context) / 2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
