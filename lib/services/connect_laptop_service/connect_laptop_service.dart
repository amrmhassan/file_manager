import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/services/services_constants.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/server_utils/encoding_utils.dart';
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
    //! i need to empty the request object from it's info and pass them to the main isolate for the listener on the ConnLaptopServiceController, yo might need to extract the request body , path , method for the outside main isolate
    //! and you might need to warn the user before clicking the back button with the connect laptop server is open
    CustomRouterSystem customRouterSystem = connectLaptopRouter();
    httpServer!.listen(
      (request) async {
        customRouterSystem.pipeline(request);
        sendRequestToMainIsolate(_service, request);
      },
    );
    port = httpServer!.port;
    _service.invoke(ServiceResActions.setLaptopServerPort, {
      'port': port,
    });
  }
}

Future<dynamic> sendRequestToMainIsolate(
  ServiceInstance s,
  HttpRequest request,
) async {
  Map<String, dynamic> headers = {};
  request.headers.forEach((name, values) {
    try {
      headers[name] = values.first;
    } catch (e) {
      logger.e(e);
    }
  });
  var requestBody = await decodeRequest(request, true);

  Completer completer = Completer();
  var requestInfo = {
    'request': request.uri.path,
    'method': request.method,
    'content': requestBody,
    'remoteIp': request.connectionInfo?.remoteAddress.address,
    'remotePort': request.connectionInfo?.remotePort,
    'headers': headers,
  };
  print(requestInfo);
  s.invoke(
    ServiceResActions.connLaptopRequests,
    requestInfo,
  );

  s.on(ServiceActions.sendResponse).listen((event) {
    print('data got from background listener, $event');
    completer.complete(event);
  });

  return completer.future;
}
