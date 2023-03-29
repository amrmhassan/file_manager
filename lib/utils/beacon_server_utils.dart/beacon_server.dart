// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/helpers/router_system/router.dart';
import 'package:explorer/helpers/router_system/server.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/beacon_server_utils.dart/beacon_server_handlers.dart';
import 'package:explorer/utils/beacon_server_utils.dart/beacon_server_middlewares.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';
import 'package:explorer/utils/server_utils/middlewares.dart';

class BeaconServer {
  HttpServer? _httpServer;

  // these ports must be static and never change for my app lifetime
  static const List<int> beaconPorts = [
    2587,
    9632,
    1596,
    8541,
  ];

  Future<HttpServer> startBeaconServer(
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) async {
    for (var port in beaconPorts) {
      try {
        _httpServer =
            await _getBeaconServerRouter(serverProvider, shareProvider, port);
        logger.i('beacon server listening on $port');
        break;
      } catch (e) {
        logger.e('port $port is used');
      }
    }
    if (_httpServer == null) {
      logger.e('server isnt set yet');
      throw Exception('Server isnt set');
    }
    return _httpServer!;
  }

  Future closeServer() async {
    await _httpServer?.close();
  }

  Future<HttpServer> _getBeaconServerRouter(
    ServerProvider serverProvider,
    ShareProvider shareProvider,
    int port,
  ) async {
    var router = CustomRouter()
        .addTrailersMiddleWare(MiddleWares.requestLogger)
        .get(
          EndPoints.getBeaconServerName,
          [],
          BSH.getServerName,
        )
        .get(
          EndPoints.getPeerImagePath,
          [],
          S1H.getUserImageHandler,
        )
        .get(
          EndPoints.getMyConnLink,
          [BSM.getMyConnLink],
          BSH.getServerConnLink,
        );

    CustomServer customServer =
        CustomServer(router, InternetAddress.anyIPv4, port);
    return customServer.bind();
  }

  //? the following code is for the client who want to search for beacon servers
  static Future<void> getWorkingDevice({
    required Function(String url, String name) onDeviceFound,
  }) async {
    List<String> links = [];
    List<String> completedInks = [];
    Completer completer = Completer();
    Dio dio = Dio();
    dio.options.sendTimeout = 10000;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    List<String> subnets = await _getMySubnets();
    // logger.i('my subnets $subnets');

    for (var subnet in subnets) {
      for (var port in beaconPorts) {
        for (var i = 0; i <= 255; i++) {
          final address = '$subnet.$i';
          links.add(address);
          String url = 'http://$address:$port';
          dio.get(url).then((value) async {
            String serverName = await _getBeaconServerName(url);
            onDeviceFound(url, serverName);
            completedInks.add(address);
            if (links.length == completedInks.length) {
              // scan finished
              if (completer.isCompleted) return;
              completer.complete();
              // logger.i('done iterations ${completedInks.length}');
            }
          }).catchError((e) {
            completedInks.add(address);
            if (links.length == completedInks.length) {
              if (completer.isCompleted) return;
              // scan finished
              completer.complete();
              // logger.i('done iterations ${completedInks.length}');
            }
          });
          await Future.delayed(Duration(milliseconds: 10));
        }
      }
    }

    return completer.future;
  }

  static Future<List<String>> _getMySubnets() async {
    List<String> myIps = await _getMyInterfacesIps();
    List<String> subnets = [];
    for (var ip in myIps) {
      var raw = ip.split('.');
      String subnet = raw.sublist(0, 3).join('.');
      if (!subnets.contains(subnet)) {
        subnets.add(subnet);
      }
    }
    return subnets;
  }

  static Future<List<String>> _getMyInterfacesIps() async {
    List<String> myIps = [];

    var interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4);
    for (var _interface in interfaces) {
      for (var address in _interface.addresses) {
        // this check if to make sure that all ips are local ips
        if (address.address.startsWith('192.168')) {
          myIps.add(address.address);
        }
      }
    }
    return myIps;
  }

  static Future<String> _getBeaconServerName(String url) async {
    var res = await Dio().get('$url${EndPoints.getBeaconServerName}');
    return res.data;
  }
}
