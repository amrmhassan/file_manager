// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/websocket_utils/custom_server_socket.dart';
import 'package:flutter/cupertino.dart';

//? when adding a new client the client can be added by any of the other clients and the adding client will send a broadcast to all other devices in the network about the new client
//? for example, adding a new client will be at /addclient and when the client is added in one of the connected devices that device will send a message to every other device in the network with /clientAdded with the new list of the clients in the network
//? including the new device which will add the clients list to his state to be used later

class ConnectLaptopProvider extends ChangeNotifier {
  int myPort = 0;
  String? myIp;
  String? remoteIP;
  int? remotePort;
  HttpServer? httpServer;
  late CustomServerSocket customServerSocket;

  late HttpServer wsServer;

  void connected(String myIp, String remoteIP, int remotePort) {
    _setMyIp(myIp);
    _setRemoteIp(remoteIP);
    _setRemotePort(remotePort);
    notifyListeners();
  }

  void _setRemotePort(int p) {
    remotePort = p;
  }

  void _setRemoteIp(String ip) {
    remoteIP = ip;
  }

  void _setMyIp(String ip) {
    myIp = ip;
  }

  Future<void> openServer() async {
    try {
      await closeServer();

      //? opening the server port and setting end points
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);

      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;

      CustomRouterSystem customRouterSystem = connectLaptopRouter(this);
      httpServer!.listen(customRouterSystem.pipeline);

      notifyListeners();
    } catch (e) {
      await closeServer();
      rethrow;
    }
  }

  //? to close the server
  Future closeServer() async {
    logger.i('Closing normal http server');
    await httpServer?.close();
    httpServer = null;
    myIp = null;
    remoteIP = null;
    remotePort = null;
    notifyListeners();
  }

  //? to restart the server
  Future restartServer() async {
    await httpServer?.close();
    await openServer();
  }
}
