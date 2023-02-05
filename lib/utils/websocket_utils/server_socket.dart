// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'socket_conn_model.dart';

class ServerSocket {
  final HttpServer httpServer;
  ServerSocket(this.httpServer);

  late Stream<WebSocket> websocketServer;
  List<SocketConnModel> sockets = [];

  Future<void> transform() async {
    websocketServer = httpServer.transform(WebSocketTransformer());
    print('Listening for sockets...');
    await for (var socket in websocketServer) {
      String si = Uuid().v4();
      print('Device Connected With si: $si');
      sockets.add(SocketConnModel(
        sessionID: si,
        webSocket: socket,
      ));
      _sendToClient(si, yourIDPath, socket);

      socket.listen(
        (event) {
          // here the server(host) will receive joining requests
          print('Message from client $si => $event');
        },
        onDone: () {
          print('Device $si disconnected');
          var copiedSockets = [...sockets];
          for (var socket in copiedSockets) {
            if (socket.sessionID == si) {
              sockets.removeWhere((element) => element.sessionID == si);
              continue;
            }

            _sendToClient(si, disconnectedIDPath, socket.webSocket);
          }
          print('Remaining devices ${sockets.length}');
        },
      );
    }
  }

  void _sendToClient(String msg, String path, WebSocket socket) {
    socket.add('$path[||]$msg');
  }
}
