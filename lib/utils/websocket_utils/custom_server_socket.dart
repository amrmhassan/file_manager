// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/utils/general_utils.dart';
import 'package:uuid/uuid.dart';

import 'constants.dart';
import 'socket_conn_model.dart';

class CustomServerSocket {
  final String myIp;
  late Stream<WebSocket> websocketServer;
  List<SocketConnModel> sockets = [];
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
  Completer<HttpServer> connLinkCompleter = Completer<HttpServer>();

//! add disconnect socket here
  Future<void> sendCloseMsg() async {
    for (var socket in sockets) {
      try {
        _sendToClient(
          'server disconnected',
          serverDisconnected,
          socket.webSocket,
        );
      } catch (e) {
        logger.e(e.toString());
      }
    }
  }

  Future<HttpServer> getWsConnLink() async {
    return connLinkCompleter.future;
  }

  Future<void> _transform(
    ServerProvider serverProviderFalse,
    ShareProvider shareProviderFalse,
  ) async {
    var server = await HttpServer.bind(myIp, 0);
    websocketServer = server.transform(WebSocketTransformer());

    connLinkCompleter.complete(server);
    logger.i('ws server listening at ${server.address.address}:${server.port}');

    await for (var socket in websocketServer) {
      String si = Uuid().v4();
      logger.i('Device Connected With si: $si');
      sockets.add(SocketConnModel(
        sessionID: si,
        webSocket: socket,
      ));
      _sendToClient(si, yourIDPath, socket);

      socket.listen(
        (event) async {
          // here the server(host) will receive joining requests
          logger.i('Message from client $si => $event');
        },
        onDone: () async {
          logger.w('Device $si disconnected');

          var copiedSockets = [...sockets];
          for (var socket in copiedSockets) {
            if (socket.sessionID == si) {
              sockets.removeWhere((element) => element.sessionID == si);
              serverProviderFalse.peerLeft(si);
              try {
                await client_utils.broadcastUnsubscribeClient(
                  serverProviderFalse,
                  shareProviderFalse,
                  si,
                );
              } catch (e) {
                logger.e(e);
              }

              continue;
            }

            // _sendToClient(si, disconnectedIDPath, socket.webSocket);
          }
          logger.i('Remaining devices ${sockets.length}');
          fastSnackBar(msg: 'Device Disconnected');
        },
      );
    }
  }

  void _sendToClient(String msg, String path, WebSocket socket) {
    logger.i('Sending to socket client path:$path msg:$msg');
    socket.add('$path[||]$msg');
  }
}
