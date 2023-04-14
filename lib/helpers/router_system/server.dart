import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';

import 'helpers/request_handler.dart';
import 'helpers/request_report.dart';
import 'router.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

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
    await _addFirewallRule(httpServer.port);
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

  Future<void> _addFirewallRule(int port) async {
    final processResult = await Process.run(
      'powershell',
      [
        'netsh',
        'advfirewall',
        'firewall',
        'add',
        'rule',
        'name="My App Rule Name"',
        'dir=in',
        'action=allow',
        'program="${Platform.resolvedExecutable}"',
        'service=any',
        'enable=yes',
        'profile=private',
        'localip=any',
        'remoteip=any',
        'localport=any',
        'remoteport=any',
        'protocol=tcp',
        'interfacetype=any',
        'security=notrequired',
      ],
    );

    if (processResult.exitCode != 0) {
      print(processResult.stderr);
    } else {
      print(processResult.stdout);
    }

    var res = processResult.stdout;

    logger.i(res);
    if (processResult.exitCode != 0) {
      print('Failed to add firewall rule: ${processResult.stderr}');
    }
  }
}
