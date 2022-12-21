// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';

ScrollController scrollController = ScrollController();

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool hidden = false;
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          if (!hidden)
            Expanded(
              child: TestListView(),
            ),
          if (hidden) Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: onTap,
                child: Text('Scroll'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    hidden = !hidden;
                  });
                },
                child: Text(!hidden ? 'Hide' : 'View'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TestListView extends StatelessWidget {
  const TestListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      children: [
        ...List.generate(
          50,
          (index) => Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            child: Text(index.toString()),
          ),
        ),
      ],
    );
  }
}

onTap() {
  if (!scrollController.hasClients) return;
  scrollController.animateTo(500,
      curve: Curves.bounceIn, duration: Duration(milliseconds: 500));
}
