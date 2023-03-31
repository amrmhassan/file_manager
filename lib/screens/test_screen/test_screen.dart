// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/TestScreen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Spacer(),
          // BeaconServersScanResultContainer(),
          ElevatedButton(
            onPressed: () async {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: Text('press'),
          ),
        ],
      ),
    );
  }
}
