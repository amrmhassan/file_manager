// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    print("Native called background task:"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await Workmanager().initialize(callbackDispatcher);
      await Workmanager().registerOneOffTask(
        'myTask',
        'myTaskCallback',
        inputData: {'message': 'Hello from Flutter!'},
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: Text(
            'Push',
          ),
        ),
      ),
    );
  }
}
