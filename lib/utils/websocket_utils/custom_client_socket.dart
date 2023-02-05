// ignore_for_file: avoid_print

import 'package:explorer/providers/server_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'constants.dart';

class CustomClientSocket {
  late IOWebSocketChannel clientChannel;
  void client(String url, ServerProvider serverProviderFalse) {
    clientChannel = IOWebSocketChannel.connect(url);
    var streamSubscription = clientChannel.stream.listen(clientSocketHandler);
    streamSubscription.onDone(
      () => onServerDisconnected(serverProviderFalse),
    );
  }

  void clientSocketHandler(dynamic event) {
    var payload = (event as String).split('[||]');
    String path = payload[0];
    String msg = payload[1];
    if (path == yourIDPath) {
      print('My ID is $msg');
    } else if (path == disconnectedIDPath) {
      print('Disconnected Device ID $msg');
    }
  }

  void onServerDisconnected(ServerProvider serverProviderFalse) {
    // here i want to close the server and the share space,
    // reset every thing in the share space
    print('Server Disconnected');
    serverProviderFalse.closeServer();
  }
}
