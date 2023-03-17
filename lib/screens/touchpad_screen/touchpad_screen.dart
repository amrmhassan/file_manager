// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/helpers/send_mouse_events.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class TouchPadScreen extends StatefulWidget {
  static const String routeName = '/TouchPadScreen';
  const TouchPadScreen({super.key});

  @override
  State<TouchPadScreen> createState() => _TouchPadScreenState();
}

class _TouchPadScreenState extends State<TouchPadScreen> {
  late SendMouseEvents sendMouseEvents;
  @override
  void initState() {
    sendMouseEvents = SendMouseEvents(
      context,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            CustomAppBar(
              title: Text(
                'Move You finger',
                style: h2TextStyle,
              ),
              rightIcon: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_forward,
                      color: kMainIconColor,
                      size: largeIconSize * .8,
                    ),
                  ),
                  HSpace(factor: .6),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onPanUpdate: (details) {
                  sendMouseEvents.moveEvent(details.delta);
                },
                onTap: () {
                  connectLaptopPF(context)
                      .ioWebSocketChannel
                      ?.innerWebSocket
                      ?.add('data');
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  width: double.infinity,
                  child: Text(
                    'This is a virtual TouchPad for your windows\nBack button won\'t work\nUse the above back button',
                    textAlign: TextAlign.center,
                    style: h4TextStyleInactive,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
