import 'dart:io';

class SocketConnModel {
  final String sessionID;
  final WebSocket webSocket;

  const SocketConnModel({
    required this.sessionID,
    required this.webSocket,
  });
}
