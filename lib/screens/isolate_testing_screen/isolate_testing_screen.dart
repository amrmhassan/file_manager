// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/helpers/storage_analyser_v1.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/folder_tree.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IsolateTestingScreen extends StatefulWidget {
  static const String routeName = '/isolate-testing-screen';
  const IsolateTestingScreen({super.key});

  @override
  State<IsolateTestingScreen> createState() => _IsolateTestingScreenState();
}

class _IsolateTestingScreenState extends State<IsolateTestingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
