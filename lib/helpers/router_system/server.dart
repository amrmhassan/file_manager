import 'dart:async';
import 'dart:io';

import 'helpers/request_handler.dart';
import 'helpers/request_report.dart';
import 'router.dart';

class CustomServer {
  final InternetAddress address;
  final int port;
  final SecurityContext? securityContext;
  late HttpServer httpServer;
  final CustomRouter router;
  final FutureOr Function(RequestReportModel tracker)? afterEachResponse;

  CustomServer(
    this.router,
    this.address,
    this.port, {
    this.securityContext,
    this.afterEachResponse,
  });
  //? to bind for listening
  Future<HttpServer> bind() async {
    if (securityContext == null) {
      httpServer = await HttpServer.bind(address, port);
    } else {
      httpServer = await HttpServer.bindSecure(address, port, securityContext!);
    }
    _handleListen();
    return httpServer;
  }

//? to handle listening for the incoming requests
  void _handleListen() {
    httpServer.listen(
      (event) => RequestHandler(
        router,
        afterEachResponse,
      ).handleManageListenEvent(event),
    );
  }
}
