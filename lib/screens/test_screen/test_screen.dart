// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = List.generate(
      50,
      (index) => Container(
        color: Colors.red,
        height: 50,
        margin: EdgeInsets.only(bottom: 20),
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          controller: scrollController,
          itemCount: data.length,
          itemBuilder: (context, index) => data[index],
        ),
      ),
    );
  }
}
