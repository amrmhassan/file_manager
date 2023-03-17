import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

// enum MouseEventsType {
//   move,
//   rightClick,
//   leftClick,
// }

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
    connectLaptopPF(context).ioWebSocketChannel?.innerWebSocket?.add(
        '${moveCursorPath}___${reversed ? dy : dx},${reversed ? dx : dy}');
  }
}
