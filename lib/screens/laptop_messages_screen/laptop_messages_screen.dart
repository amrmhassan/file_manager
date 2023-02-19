// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class LaptopMessagesScreen extends StatefulWidget {
  static const String routeName = '/LaptopMessagesScreen';
  const LaptopMessagesScreen({super.key});

  @override
  State<LaptopMessagesScreen> createState() => _LaptopMessagesScreenState();
}

class _LaptopMessagesScreenState extends State<LaptopMessagesScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) {
        connectLaptopPF(context).markAllMessagesAsViewed();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var connLapProvider = connectLaptopP(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text('Laptop Messages'),
          ),
          VSpace(),
        ],
      ),
    );
  }
}
