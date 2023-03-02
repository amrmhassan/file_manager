import 'dart:async';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/rendering.dart';
import 'package:web_socket_channel/io.dart';
import 'constants.dart';

class CustomClientSocket {
  final Completer<String> mySessionIDCompleter = Completer<String>();
  final VoidCallback? onServerDisconnected;
  late String mySessionID;
  late IOWebSocketChannel clientChannel;

  CustomClientSocket({
    this.onServerDisconnected,
  });

  Future<String> getMySessionID() async {
    return mySessionIDCompleter.future;
  }

  void client(
    String url,
    ServerProvider? serverProviderFalse,
  ) {
    logger.i('connecting to ws server at $url');
    clientChannel = IOWebSocketChannel.connect(url);
    var streamSubscription = clientChannel.stream.listen(
      (event) => _clientSocketHandler(event, serverProviderFalse),
    );
    streamSubscription.onDone(
      onServerDisconnected ?? () => _onServerDisconnected(serverProviderFalse),
    );
  }

  void _clientSocketHandler(
    dynamic event,
    ServerProvider? serverProviderFalse,
  ) {
    if (serverProviderFalse == null) return;
    var payload = (event as String).split('[||]');
    String path = payload[0];
    String msg = payload[1];
    if (path == yourIDPath) {
      logger.i('My Session ID is $msg');
      mySessionIDCompleter.complete(msg);
    } else if (path == disconnectedIDPath) {
      logger.w('Disconnected Device ID $msg');
    } else if (path == serverDisconnected) {
      if (onServerDisconnected == null) {
        _onServerDisconnected(serverProviderFalse);
      } else {
        onServerDisconnected!();
      }
    }
  }

  void _onServerDisconnected(ServerProvider? serverProviderFalse) {
    if (serverProviderFalse == null) return;

    // here i want to close the server and the share space,
    // reset every thing in the share space
    logger.w('Server Disconnected');
    serverProviderFalse.closeServer();
    fastSnackBar(
      msg: 'Host Disconnected',
      snackBarType: SnackBarType.error,
    );
  }
}
