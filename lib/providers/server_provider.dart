import 'dart:io';

import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/server_utils/ip_utils.dart';
import 'package:explorer/utils/server_utils/server_requests.dart';
import 'package:flutter/cupertino.dart';

import '../models/peer_model.dart';

class ServerProvider extends ChangeNotifier {
  String? myConnLink;
  int myPort = 0;
  String? myIp;
  HttpServer? httpServer;
  List<PeerModel> peers = [];

  //? send file
  Future openServer(String deviceID, [bool wifi = true]) async {
    httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);
    myPort = httpServer!.port;
    String? myWifiIp = await getMyIpAddress(wifi);
    if (myWifiIp == null) {
      throw Exception('Ip is null');
    }
    myIp = myWifiIp;
    myConnLink = 'http://$myWifiIp:$myPort';
    PeerModel meHost = PeerModel(
      deviceID: deviceID,
      joinedAt: DateTime.now(),
      name: 'peer name will be here',
      memberType: MemberType.host,
    );
    peers.add(meHost);
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
}
