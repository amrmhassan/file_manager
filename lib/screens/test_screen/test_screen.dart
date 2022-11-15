// ignore_for_file: prefer_const_constructors

import 'dart:isolate';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class IsolateData {
  final int end;
  final int start;
  const IsolateData(this.start, this.end);
}

void heavyWork(SendPort sendPort) {
  ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    IsolateData isolateData = message;
    int sum = 0;
    for (var i = isolateData.start; i <= isolateData.end; i++) {
      sum += i;
    }
    sendPort.send(sum);
  });
}

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Isolate? myIsolate;

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          TextButton(
            onPressed: () async {
              ReceivePort receivePort = ReceivePort();
              SendPort sendPort = receivePort.sendPort;
              myIsolate = await Isolate.spawn(heavyWork, sendPort);
              receivePort.listen((message) {
                if (message is int) {
                } else {
                  SendPort sendPort = message as SendPort;
                  sendPort.send(IsolateData(0, 1000000));
                }
              });
            },
            child: Text('Start Isolate'),
          ),
          TextButton(
            onPressed: () async {
              myIsolate!.kill();
            },
            child: Text('Kill Isolate'),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
