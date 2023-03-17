import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SendMouseEvents {
  late WebSocket? socket;
  final BuildContext context;

  SendMouseEvents(
    this.context,
  ) {
    socket = connectLaptopPF(context).ioWebSocketChannel?.innerWebSocket;
  }

  void moveEvent(Offset delta) {
    bool reversed = false;

    double sensitivity = 3;
    int dx = (delta.dx * sensitivity).ceil();
    int dy = (delta.dy * sensitivity).ceil();
    _add('${moveCursorPath}___${reversed ? dy : dx},${reversed ? dx : dy}');
  }

  void rightClick() {
    _add(mouseRightClickedPath);
  }

  void leftClick() {
    _add(mouseLeftClickedPath);
  }

  void leftDown() {
    _add(mouseLeftDownPath);
  }

  void leftUp() {
    _add(mouseLeftUpPath);
  }

  void _add(dynamic data) {
    connectLaptopPF(context).ioWebSocketChannel?.innerWebSocket?.add(data);
    if (data.toString().startsWith(moveCursorPath)) return;
    print(data);
  }
}
