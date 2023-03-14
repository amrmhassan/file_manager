import 'dart:io';

import 'package:explorer/services/services_constants.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class ConnectLaptopService {
  final ServiceInstance _service;

//! to fix the error you need to get all info you need from the main isolate before opening the server and set it in this class
  ConnectLaptopService(this._service);

  HttpServer? httpServer;

  Future<void> openServer(Map<String, dynamic>? event) async {
    int port = event!['port'];
    httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
    CustomRouterSystem customRouterSystem = connectLaptopRouter();
    httpServer!.listen(customRouterSystem.pipeline);
    port = httpServer!.port;
    //! send the port here
    _service.invoke(ServiceResActions.setLaptopServerPort, {
      'port': port,
    });
  }
}
