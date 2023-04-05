// ignore_for_file: prefer_const_constructors

import './mouse_controller.dart';

Future<void> handleMoveMouseTest() async {
  var p1 = Position(787, 430);
  MouseController mouseController = MouseController();
  await Future.delayed(Duration(milliseconds: 2000));

  mouseController.setCursorPosition(p1.x, p1.y);

  mouseController.leftMouseButtonDown();
  for (var i = 0; i < 200; i++) {
    mouseController.setCursorPosition(p1.x + i, p1.y + i);
    await Future.delayed(Duration(milliseconds: 1));
  }

  await Future.delayed(Duration(milliseconds: 1000));
  // mouseController.leftMouseButtonUp();
}
