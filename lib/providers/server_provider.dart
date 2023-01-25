import 'dart:io';

import 'package:explorer/utils/server_utils/server_requests.dart';
import 'package:flutter/cupertino.dart';

class ServerProvider extends ChangeNotifier {
  String? myConnLink;
  int myPort = 0;
  String? myIp;
  HttpServer? httpServer;

  //? send file
  Future openServer([bool wifi = true]) async {
    httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);
    myPort = httpServer!.port;
    String? myWifiIp = await getMyIpAddress(wifi);
    if (myWifiIp == null) {
      throw Exception('Ip is null');
    }
    myIp = myWifiIp;
    myConnLink = 'http://$myWifiIp:$myPort';
    notifyListeners();

    httpServer!.listen((HttpRequest request) async {
      handleServerRequests(request);
    });
  }

  Future closeServer() async {
    await httpServer!.close();
    httpServer = null;
    notifyListeners();
  }

  //? get my wifi address
  Future<String?> getMyIpAddress([bool wifi = true]) async {
    //! this might change for other devices
    // 192.168.43.99   => wlan0 == mostly wifi
    // 192.168.118.237 => wlan1 == mostly hotspot
    try {
      var interfaces = await NetworkInterface.list();
      var wifiInterface = interfaces.firstWhere((element) =>
          element.name.contains(wifi ? 'wlan0' : 'wlan1') ||
          element.name.contains('wifi'));
      // return null;
      return wifiInterface.addresses.first.address;
    } catch (e) {
      return null;
    }
  }
}
