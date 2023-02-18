// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:explorer/utils/providers_calls_utils.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    var connectPhoneProvider = connectLaptopP(context);
    if (connectPhoneProvider.remoteIP == null) {
      if (Navigator.canPop(context)) {
        Future.delayed(Duration.zero).then((value) {
          Navigator.pop(context);
        });
      }
    }
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                're data is ${connectPhoneProvider.remoteIP}:${connectPhoneProvider.remotePort}'),
            Text(
                'my data is ${connectPhoneProvider.myIp}:${connectPhoneProvider.myPort}'),
          ],
        ),
      ),
    );
  }
}
