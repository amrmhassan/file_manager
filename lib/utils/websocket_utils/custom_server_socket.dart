// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/utils/general_utils.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/mouse_data/mouse_controller.dart';
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
      MouseEventsHandler mouseEventsHandler = MouseEventsHandler();

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
          mouseEventsHandler.handleMouseReceiveEvents(event);
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

class MouseEventsHandler {
  bool sleeping = false;
  List<String> sleepingCommands = [];

  void handleMouseReceiveEvents(dynamic event) async {
    var data = event.toString().split('___');
    String path = data.first;
    String message = data.last;

    MouseController mouseController = MouseController();
    if (sleeping) {
      sleepingCommands.add(event);
      return;
    }
    if (path == SocketPaths.moveCursorPath) {
      // move the cursor
      var positionData = message.split(',');
      int dx = double.parse(positionData.first).round();
      int dy = double.parse(positionData.last).round();
      mouseController.setCursorPositionDelta(dx, dy);
    } else if (path == SocketPaths.mouseLeftClickedPath) {
      mouseController.leftMouseButtonDown();
      mouseController.leftMouseButtonUp();
    } else if (path == SocketPaths.mouseRightClickedPath) {
      mouseController.rightMouseButtonDown();
      mouseController.rightMouseButtonUp();
    } else if (path == SocketPaths.mouseLeftDownPath) {
      mouseController.leftMouseButtonDown();
    } else if (path == SocketPaths.mouseLeftUpPath) {
      mouseController.leftMouseButtonUp();
    } else if (path == SocketPaths.mouseEventClickDrag) {
      Future.delayed(Duration(milliseconds: 0)).then((value) {
        sleeping = false;
        for (var element in sleepingCommands) {
          handleMouseReceiveEvents(element);
        }
        sleepingCommands.clear();
      });

      logger.e('should wait here before any mouse events ');
      // i might sleep here and add a list of events that need to be done,
      // and after this sleep period i execute all events first
      // so i will add a variable bool sleeping = false
      // if android tells me to sleep i will sleep for about 200ms or less and will record all events
      // after sleeping period is done i will execute all sleeping commands
      sleeping = true;
    }
  }
}
