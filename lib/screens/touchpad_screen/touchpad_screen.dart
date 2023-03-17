// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_line.dart';
import 'package:explorer/helpers/send_mouse_events.dart';
import 'package:flutter/material.dart';

class TouchPadScreen extends StatefulWidget {
  static const String routeName = '/TouchPadScreen';
  const TouchPadScreen({super.key});

  @override
  State<TouchPadScreen> createState() => _TouchPadScreenState();
}

class _TouchPadScreenState extends State<TouchPadScreen> {
  bool doubleTapped = false;
  late MouseEvents mouseEvents;

  @override
  void initState() {
    mouseEvents = MouseEvents(context);
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
                  mouseEvents.move(details.delta);
                },
                onTapDown: (details) {
                  mouseEvents.panDownEvent();
                },
                onTapUp: (details) {
                  // bsend left mouse up event
                  mouseEvents.panUpEvent();
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
            HLine(
              color: kMainIconColor.withOpacity(.2),
            ),
            Row(
              children: [
                Expanded(
                  child: ButtonWrapper(
                    borderRadius: 0,
                    height: 100,
                    onTap: () {
                      mouseEvents.leftClick();
                    },
                    backgroundColor: kBackgroundColor,
                    child: SizedBox(),
                  ),
                ),
                VLine(
                  height: 100,
                  color: kMainIconColor.withOpacity(.2),
                ),
                Expanded(
                  child: ButtonWrapper(
                    borderRadius: 0,
                    height: 100,
                    onTap: () {
                      mouseEvents.rightClick();
                    },
                    backgroundColor: kBackgroundColor,
                    child: SizedBox(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MouseEvents {
  final BuildContext _context;
  late SendMouseEvents sendMouseEvents;
  bool _mouseDown = false;

  MouseEvents(this._context) {
    sendMouseEvents = sendMouseEvents = SendMouseEvents(
      _context,
    );
  }

  void panDownEvent() {
    _mouseDown = true;
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      if (!_mouseDown) {
        // this mean that the user have made up event before the time ends, so it was a click not a move event
        sendMouseEvents.leftDown();
        sendMouseEvents.leftUp();
      }
      _mouseDown = false;
    });
  }

  void panUpEvent() {
    _mouseDown = false;
  }

  void move(Offset delta) {
    sendMouseEvents.moveEvent(delta);
  }

  void leftClick() {
    sendMouseEvents.leftClick();
  }

  void rightClick() {
    sendMouseEvents.rightClick();
  }
}
