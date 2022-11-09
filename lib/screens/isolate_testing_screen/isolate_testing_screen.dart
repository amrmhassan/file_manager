// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

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
