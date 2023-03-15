import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/services/background_service.dart';
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
        .listen((event) async {
      File loggingTestFile = File('sdcard/logging.txt');
      if (!loggingTestFile.existsSync()) {
        loggingTestFile.createSync();
      }
      var raf = await loggingTestFile.open(mode: FileMode.append);
      String data =
          '$event--${DateTime.now().toIso8601String()}\n-----------------------\n';
      raf.writeStringSync(data);
      raf.closeSync();

      print(event);
      //? getting the response for the background service here
      flutterBackgroundService.invoke(ServiceActions.sendResponse, event);
    });
  }
}
