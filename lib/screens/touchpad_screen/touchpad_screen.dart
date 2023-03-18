// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_line.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/send_mouse_events.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
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
      onWillPop: () {
        showSnackBar(
            context: context,
            message: 'Press the above back button',
            snackBarType: SnackBarType.error);
        return Future.value(false);
      },
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
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) {
                  mouseEvents.move(details.delta);
                },
                onTapDown: (details) {
                  mouseEvents.panDownEvent();
                },
                onTapUp: (details) {
                  mouseEvents.panUpEvent();
                },
                onPanEnd: (details) {
                  mouseEvents.panUpEvent(true);
                },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: double.infinity),
                      Text(
                        'This is a virtual TouchPad for your windows\nBack button won\'t work\nUse the above back button',
                        textAlign: TextAlign.center,
                        style: h4TextStyleInactive,
                      ),
                      VSpace(factor: .5),
                      Text(
                        'Still Under Development',
                        textAlign: TextAlign.center,
                        style:
                            h4TextStyleInactive.copyWith(color: kDangerColor),
                      ),
                    ],
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

// class MouseEvents {
//   final BuildContext _context;
//   late SendMouseEvents sendMouseEvents;

//   MouseEvents(this._context) {
//     sendMouseEvents = sendMouseEvents = SendMouseEvents(
//       _context,
//     );
//   }

//   void panDownEvent() {
//     sendMouseEvents.leftDown();
//   }

//   void panUpEvent() {
//     sendMouseEvents.leftUp();
//   }

//   void move(Offset delta) {
//     sendMouseEvents.moveEvent(delta);
//   }

//   void leftClick() {
//     sendMouseEvents.leftClick();
//   }

//   void rightClick() {
//     sendMouseEvents.rightClick();
//   }
// }

//? my old version
class MouseEvents {
  final BuildContext _context;
  late SendMouseEvents sendMouseEvents;
  bool _mouseDown = false;
  bool normalClick = false;

  MouseEvents(this._context) {
    sendMouseEvents = sendMouseEvents = SendMouseEvents(_context);
  }

  void panDownEvent() {
    _mouseDown = true;
    if (normalClick) {
      sendMouseEvents.leftDown();

      return;
    }
    Future.delayed(Duration(milliseconds: 50)).then((value) {
      if (!_mouseDown) {
        // this mean that the user have made up event before the time ends, so it was a click not a move event
        sendMouseEvents.leftDown();

        //!
        panUpEvent(true);
        normalClick = true;

        Future.delayed(Duration(milliseconds: 200)).then((value) {
          normalClick = false;
        });
      }
      _mouseDown = false;
    });
  }

  void panUpEvent([bool send = false]) {
    _mouseDown = false;
    if (send || _mouseDown) {
      sendMouseEvents.leftUp();
    }
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


//? ChatGPT version

// class MouseEvents {
//   final BuildContext _context;
//   late SendMouseEvents sendMouseEvents;
//   bool _mouseDown = false;
//   Offset _startPosition = Offset.zero;

//   MouseEvents(this._context) {
//     sendMouseEvents = SendMouseEvents(
//       _context,
//     );
//   }

//   void panDownEvent(Offset position) {
//     _startPosition = position;
//     _mouseDown = true;
//     sendMouseEvents.leftDown();
//   }

//   void panUpEvent() {
//     _mouseDown = false;
//     _startPosition = Offset.zero;
//     sendMouseEvents.leftUp();
//   }

//   void move(Offset currentPosition) {
//     final delta = currentPosition - _startPosition;
//     sendMouseEvents.moveEvent(delta);
//   }

//   void onTap(Offset position) {
//     sendMouseEvents.leftClick();
//   }

//   void onTapDown(Offset position) {
//     panDownEvent(position);
//   }

//   void onTapUp(Offset position) {
//     panUpEvent();
//   }

//   void leftClick() {
//     sendMouseEvents.leftClick();
//   }

//   void rightClick() {
//     sendMouseEvents.rightClick();
//   }
// }

// class SendMouseEvents {
//   final BuildContext context;

//   SendMouseEvents(this.context);

//   Future<void> moveEvent(Offset delta) async {
//     await _sendEvent(PointerEvent.change(delta: delta));
//   }

//   Future<void> leftClick() async {
//     await _sendEvent(PointerEvent.down(
//       pointer: 0,
//       buttons: kPrimaryMouseButton,
//     ));
//     await _sendEvent(PointerEvent.up(
//       pointer: 0,
//       buttons: kPrimaryMouseButton,
//     ));
//   }

//   Future<void> rightClick() async {
//     await _sendEvent(PointerEvent.down(
//       pointer: 0,
//       buttons: kSecondaryMouseButton,
//     ));
//     await _sendEvent(PointerEvent.up(
//       pointer: 0,
//       buttons: kSecondaryMouseButton,
//     ));
//   }

//   Future<void> leftDown() async {
//     await _sendEvent(PointerEvent.down(
//       pointer: 0,
//       buttons: kPrimaryMouseButton,
//     ));
//   }

//   Future<void> leftUp() async {
//     await _sendEvent(PointerEvent.up(
//       pointer: 0,
//       buttons: kPrimaryMouseButton,
//     ));
//   }

//   Future<void> _sendEvent(PointerEvent event) async {
//     final result = await GestureBinding.instance!.handlePointerEvent(event);
//     if (result != PointerRoute.didNotFind) {
//       await Future.delayed(Duration(milliseconds: 16));
//     }
//   }
// }
