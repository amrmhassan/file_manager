import 'dart:async';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/services/background_service.dart';
import 'package:explorer/services/connect_laptop_service/connect_laptop_service.dart';
import 'package:explorer/services/services_constants.dart';

class ConnLaptopServiceController {
  static Future<int> openServer(int port) async {
    StreamSubscription? sub;
    Completer<int> completer = Completer<int>();
    flutterBackgroundService.invoke(ServiceActions.openLaptopServer, {
      'port': port,
      'intialDirs': initialDirs.map((e) => e.path).toList(),
    });

    sub = flutterBackgroundService
        .on(ServiceResActions.setLaptopServerPort)
        .listen((event) {
      int port = event!['port'];
      completer.complete(port);
      //! listening for the background service events
      listenForRequests();
      sub?.cancel();
    });
    return completer.future;
  }

  static Future<void> listenForRequests() async {
    flutterBackgroundService
        .on(ServiceResActions.connLaptopRequests)
        .listen((event) {
      logger.e(helperHTTPCarriar.httpServer);
      print(event);
    });
  }
}
