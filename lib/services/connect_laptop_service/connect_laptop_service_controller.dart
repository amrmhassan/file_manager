import 'dart:async';

import 'package:explorer/services/background_service.dart';
import 'package:explorer/services/services_constants.dart';

class ConnLaptopServiceController {
  static Future<int> openServer(int port) async {
    StreamSubscription? sub;
    Completer<int> completer = Completer<int>();
    flutterBackgroundService.invoke(ServiceActions.openLaptopServer, {
      'port': port,
    });

    sub = flutterBackgroundService
        .on(ServiceResActions.setLaptopServerPort)
        .listen((event) {
      int port = event!['port'];
      completer.complete(port);
      sub?.cancel();
    });
    return completer.future;
  }
}
