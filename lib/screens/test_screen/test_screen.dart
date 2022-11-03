// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  ScrollController scrollController = ScrollController();
  Directory directory = Directory('sdcard/DCIM/Camera');

  List<FileSystemEntity> children = [];
  @override
  void initState() {
    var stream = directory.list(recursive: false);
    stream.listen((event) {
      setState(() {
        children.add(event);
      });
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   scrollController.addListener(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(children.length.toString()),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(children[index].path),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
