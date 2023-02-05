// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'socket_conn_model.dart';

class CustomServerSocket {
  final String myIp;
  CustomServerSocket(
    this.myIp,
    ServerProvider serverProviderFalse,
    ShareProvider shareProviderFalse,
  ) {
    _transform(
      serverProviderFalse,
      shareProviderFalse,
    );
  }
  Completer<String> connLinkCompleter = Completer<String>();

  Future<String> getWsConnLink() async {
    return connLinkCompleter.future;
  }

  late Stream<WebSocket> websocketServer;
  List<SocketConnModel> sockets = [];

  Future<void> _transform(
    ServerProvider serverProviderFalse,
    ShareProvider shareProviderFalse,
  ) async {
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    websocketServer = server.transform(WebSocketTransformer());
    String connLink = getConnLink(myIp, server.port, true);
    connLinkCompleter.complete(connLink);
    print('SocketServer $connLink');

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

            // _sendToClient(si, disconnectedIDPath, socket.webSocket);
            client_utils.broadcastUnsubscribeClient(
              serverProviderFalse,
              shareProviderFalse,
            );
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
