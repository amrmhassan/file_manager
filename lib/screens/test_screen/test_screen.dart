// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:permission_handler/permission_handler.dart';

class TestScreen extends StatelessWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Directory directory = Directory('sdcard/Books');
            var data = directory.listSync();
            print(data.length);
          },
          child: Text('Click Me'),
        ),
      ),
    );
  }
}
