// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/ip_utils.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../models/peer_model.dart';

//? when adding a new client the client can be added by any of the other clients and the adding client will send a broadcast to all other devices in the network about the new client
//? for example, adding a new client will be at /addclient and when the client is added in one of the connected devices that device will send a message to every other device in the network with /clientadded with the new list of the clients in the network
//? including the new device which will add the clients list to his state to be used later

class ServerProvider extends ChangeNotifier {
  String? myConnLink;
  int myPort = 0;
  String? myIp;
  HttpServer? httpServer;
  List<PeerModel> peers = [];

//? update all peers
  void updateAllPeers(List<Map<String, dynamic>> newPeersList) {
    peers = newPeersList
        .map(
          (e) => PeerModel(
            deviceID: e['deviceID'] as String,
            joinedAt: DateTime.parse(e['joinedAt']),
            name: e['name'],
            memberType: stringToEnum(e['memberType'], MemberType.values),
            ip: e['ip'],
            port: e['port'],
            sessionID: e['sessionsID'],
          ),
        )
        .toList();
    notifyListeners();
  }

  //? send file
  Future<void> openServer(ShareProvider shareProvider,
      [bool wifi = true]) async {
    //? opening the server port and setting end points
    httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);
    CustomRouterSystem customRouterSystem =
        addServerRouters(this, shareProvider);
    httpServer!.listen(customRouterSystem.handleListen);
//? when above code is success then set the needed stuff like port, other things
    myPort = httpServer!.port;
    String? myWifiIp = await getMyIpAddress(wifi);
    if (myWifiIp == null) {
      throw Exception('Ip is null');
    }
    myIp = myWifiIp;
    myConnLink = 'http://$myWifiIp:$myPort';

    PeerModel meHost = PeerModel(
      deviceID: shareProvider.myDeviceId,
      joinedAt: DateTime.now(),
      name: 'peer name will be here',
      memberType: MemberType.host,
      ip: myIp!,
      port: myPort,
      sessionID: Uuid().v4(),
    );
    peers.add(meHost);
    notifyListeners();
  }

//? to close the server
  Future closeServer() async {
    await httpServer!.close();
    httpServer = null;
    peers.clear();
    myConnLink = null;
    myIp = null;
    notifyListeners();
  }

  //? to restart the server
  Future restartServer(ShareProvider shareProvider) async {
    await closeServer();
    await openServer(shareProvider);
  }

  //# server functions
  PeerModel addPeer(String clientId, String name, String ip, int port) {
    // if the peer is already registered
    // this might mean that he disconnected
    // so i will replace the current session with the new one
    bool exists = peers.any((element) => element.deviceID == clientId);
    String sessionID = Uuid().v4();
    PeerModel peerModel = PeerModel(
      deviceID: clientId,
      joinedAt: DateTime.now(),
      name: name,
      memberType: MemberType.client,
      ip: ip,
      port: port,
      sessionID: sessionID,
    );
    if (exists) {
      printOnDebug(
          'This device is already registered, replacing the existing one');
      int index = peers.indexWhere((element) => element.deviceID == clientId);

      peers[index] = peerModel;
      notifyListeners();
      return peerModel;
    }
    peers.add(peerModel);
    notifyListeners();

    return peerModel;
  }

//? this will be used when a new device is connected
  void broadcastToAllClients() {
    //? here i will send a normal http request to all clients from the peers except me of course
    //? this should run only from the server(hotspot) device and it will be only one such a device in the network
  }

  //? when an item is added to share space the adding device will send a message to all connected devices to him
}
