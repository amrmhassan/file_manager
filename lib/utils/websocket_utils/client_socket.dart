// ignore_for_file: avoid_print

import 'package:web_socket_channel/io.dart';

import 'constants.dart';

class ClientSocket {
  void client(String url) {
    final channel = IOWebSocketChannel.connect(url);
    channel.sink.add('start');
    channel.stream.listen(clientSocketHandler).onDone(onServerDisconnected);
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

  void onServerDisconnected() {
    print('Server Disconnected');
  }
}
