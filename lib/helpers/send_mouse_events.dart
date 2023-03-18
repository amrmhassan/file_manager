// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SendMouseEvents {
  late WebSocket? socket;
  final BuildContext context;
  bool dontSend = false;

  List<String> lastEvents = [];

  SendMouseEvents(
    this.context,
  ) {
    socket = connectLaptopPF(context).ioWebSocketChannel?.innerWebSocket;
  }

  void moveEvent(Offset delta) {
    double sensitivity = 3;
    int dx = (delta.dx * sensitivity).ceil();
    int dy = (delta.dy * sensitivity).ceil();
    _add('${moveCursorPath}___$dx,$dy');
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

  void _add(dynamic data) async {
    String event = data.toString().split('___').first;
    if (event == mouseLeftDownPath &&
        lastEvents.length == 2 &&
        lastEvents.first == mouseLeftDownPath &&
        lastEvents.last == mouseLeftUpPath) {
      // this mean the user is about to click and drag so i wont send the latest 2 events of down then up
      // so i will set a var dontSend to be true
      // in this case i will make a delay between sending events and receiving them

      // so here i must record the current mouse position and send it
      // and the waiting option should happen on the windows stuff
      connectLaptopPF(context)
          .ioWebSocketChannel
          ?.innerWebSocket
          ?.add(mouseEventClickDrag);
    }

    connectLaptopPF(context).ioWebSocketChannel?.innerWebSocket?.add(data);
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      lastEvents.clear();
    });

    if (lastEvents.isEmpty) {
      lastEvents.add(event);
    } else if (lastEvents.last != moveCursorPath) {
      lastEvents.add(event);
    }
  }
}
