import 'dart:async';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'constants.dart';

class CustomClientSocket {
  late String mySessionID;
  Completer<String> mySessionIDCompleter = Completer<String>();

  Future<String> getMySessionID() async {
    return mySessionIDCompleter.future;
  }

  late IOWebSocketChannel clientChannel;
  void client(String url, ServerProvider serverProviderFalse) {
    logger.i('connecting to ws server at $url');
    clientChannel = IOWebSocketChannel.connect(url);
    var streamSubscription = clientChannel.stream.listen(
      (event) => clientSocketHandler(event, serverProviderFalse),
    );
    streamSubscription.onDone(
      () => onServerDisconnected(serverProviderFalse),
    );
  }

  void clientSocketHandler(dynamic event, ServerProvider serverProviderFalse) {
    var payload = (event as String).split('[||]');
    String path = payload[0];
    String msg = payload[1];
    if (path == yourIDPath) {
      logger.i('My ID is $msg');
      mySessionIDCompleter.complete(msg);
    } else if (path == disconnectedIDPath) {
      logger.w('Disconnected Device ID $msg');
    } else if (path == serverDisconnected) {
      onServerDisconnected(serverProviderFalse);
    }
  }

  void onServerDisconnected(ServerProvider serverProviderFalse) {
    // here i want to close the server and the share space,
    // reset every thing in the share space
    logger.w('Server Disconnected');
    serverProviderFalse.closeServer();
  }
}
