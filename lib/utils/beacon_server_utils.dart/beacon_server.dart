// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/utils/server_utils/handlers/handlers.dart';

class BeaconServer {
  final String _connLinkQueryEncoded;
  HttpServer? _httpServer;

  BeaconServer(this._connLinkQueryEncoded);

// these ports must be static and never change for my app lifetime
  static const List<int> beaconPorts = [
    2587,
    9632,
    1596,
    8541,
  ];

  Future<HttpServer> startBeaconServer() async {
    for (var port in beaconPorts) {
      try {
        _httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
        break;
      } catch (e) {
        logger.e('port $port is used');
      }
    }
    if (_httpServer == null) {
      logger.e('server isnt set yet');
      throw Exception('Server isnt set');
    }
    //? here you can use the http server
    HttpServer validServer = _httpServer!;
    validServer.listen((request) {
      String path = request.uri.path;
      logger.i(
          'beacon server received a scan from ${request.connectionInfo!.remoteAddress.address}:${request.connectionInfo!.remotePort}');
      if (path == '/') {
        // here return the query connLink
        request.response
          ..write(_connLinkQueryEncoded)
          ..close();
      } else if (path == EndPoints.getPeerImagePath) {
        S1H.getUserImageHandler(request, request.response);
      }
    });
    return _httpServer!;
  }

  Future closeServer() async {
    await _httpServer?.close();
  }

  static Future<void> getWorkingDevice({
    required Function(String query) onDeviceFound,
  }) async {
    List<String> links = [];
    List<String> completedInks = [];
    Completer completer = Completer();
    Dio dio = Dio();
    dio.options.sendTimeout = 5000;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
    List<String> subnets = await _getMySubnets();
    logger.i(subnets);

    for (var subnet in subnets) {
      for (var port in beaconPorts) {
        for (var i = 0; i <= 255; i++) {
          final address = '$subnet.$i';
          links.add(address);
          String url = 'http://$address:$port';
          dio.get(url).then((value) {
            onDeviceFound(value.data);
            completedInks.add(address);
            if (links.length == completedInks.length) {
              // scan finished
              completer.complete();
              logger.i('done iterations ${completedInks.length}');
            }
          }).catchError((e) {
            completedInks.add(address);
            if (links.length == completedInks.length) {
              // scan finished
              completer.complete();
              logger.i('done iterations ${completedInks.length}');
            }
          });
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
}
