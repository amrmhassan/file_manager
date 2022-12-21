// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

PageController pageController = PageController();

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int activeViewIndex = 0;
  bool hidden = false;

  void forward() {
    setState(() {
      activeViewIndex++;
    });
    pageController.animateToPage(activeViewIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void backward() {
    setState(() {
      activeViewIndex--;
    });
    pageController.animateToPage(activeViewIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    pageController = PageController(
      initialPage: activeViewIndex,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          hidden
              ? Expanded(child: SizedBox())
              : Expanded(
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (value) {
                      setState(() {
                        activeViewIndex = value;
                      });
                    },
                    children: [
                      Container(
                        color: Colors.red,
                      ),
                      Container(
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: activeViewIndex <= 0
                    ? null
                    : () {
                        backward();
                      },
                child: Text('Left'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
                child: Text(hidden ? 'Show' : 'Hide'),
              ),
              ElevatedButton(
                onPressed: activeViewIndex >= 1
                    ? null
                    : () {
                        forward();
                      },
                child: Text('Right'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
