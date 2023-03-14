import 'dart:io';

import 'package:explorer/services/services_constants.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

late List<Directory> backgroundServiceInitlaDirs;

class ConnectLaptopService {
  final ServiceInstance _service;

  ConnectLaptopService(this._service);

  HttpServer? httpServer;

  Future<void> openServer(Map<String, dynamic>? event) async {
    int port = event!['port'];
    backgroundServiceInitlaDirs = (event['intialDirs'] as List<dynamic>)
        .map((e) => Directory(e))
        .toList();
    //
    httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
    CustomRouterSystem customRouterSystem = connectLaptopRouter();
    httpServer!.listen(customRouterSystem.pipeline);
    port = httpServer!.port;
    _service.invoke(ServiceResActions.setLaptopServerPort, {
      'port': port,
    });
  }
}
