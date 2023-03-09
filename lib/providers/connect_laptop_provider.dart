// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/laptop_message_model.dart';
import 'package:explorer/utils/client_utils.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/websocket_utils/custom_client_socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

int connectLaptopPort = 0;

class ConnectLaptopProvider extends ChangeNotifier {
  int myPort = 0;
  String? myIp;
  String? remoteIP;
  int? remotePort;
  HttpServer? httpServer;
  IOWebSocketChannel? ioWebSocketChannel;
  WebSocketSink? myClientWsSink;

  late HttpServer wsServer;

  void setMyWsChannel(WebSocketSink s) {
    logger.i('setting ws sink (WebSocketSink) variable');
    myClientWsSink = s;
    notifyListeners();
  }

  void _connected(String myIp, String remoteIP, int remotePort) {
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

  Future<void> _openServer() async {
    try {
      await closeServer();

      //? opening the server port and setting end points
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);

      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;
      connectLaptopPort = myPort;

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
    myPort = 0;
    ioWebSocketChannel = null;
    myClientWsSink?.close();
    notifyListeners();
  }

  Future<bool> handleConnect(Object? code) async {
    if (code is! String) return false;
    String? ip = await _getWorkingIp(code);
    logger.i('Working Ip is $ip');
    if (ip == null) {
      await closeServer();
      return false;
    }
    String wsConnLink = (await Dio().get(
            getConnLink(remoteIP!, remotePort!, phoneWsServerConnLinkEndPoint)))
        .data;
    CustomClientSocket customClientSocket = CustomClientSocket(
      onServerDisconnected: () {
        logger.w('Laptop disconnected');
        fastSnackBar(msg: 'Laptop disconnected');
        closeServer();
      },
    );
    customClientSocket.client(wsConnLink, null);
    ioWebSocketChannel = customClientSocket.clientChannel;
    //! set the channel here
    myClientWsSink = customClientSocket.clientChannel.sink;

    notifyListeners();
    return true;
  }

  Future<String?> _getWorkingIp(String code) async {
    await _openServer();
    var res = await getWorkingIpFromCode(
      code: code,
      myPort: myPort,
    );
    if (res == null) return null;
    _connected(res.myIp, res.serverIp, res.serverPort);
    return res.serverIp;
  }

  String getPhoneConnLink(String? endpoint) {
    return getConnLink(remoteIP!, remotePort!, endpoint);
  }

  //# message that will come from the laptop
  List<LaptopMessageModel> _laptopMessages = [];

  List<LaptopMessageModel> get laptopMessages => [..._laptopMessages.reversed];

  List<LaptopMessageModel> get viewedLaptopMessages =>
      _laptopMessages.where((element) => element.viewed).toList();

  List<LaptopMessageModel> get notViewedLaptopMessages =>
      _laptopMessages.where((element) => !element.viewed).toList();

  void addLaptopMessage(String msg) {
    _laptopMessages.add(LaptopMessageModel(
      msg: msg,
      at: DateTime.now(),
      id: Uuid().v4(),
    ));
    notifyListeners();
  }

  void markAllMessagesAsViewed([bool notify = true]) {
    _laptopMessages = [
      ..._laptopMessages.map((e) {
        e.viewed = true;
        return e;
      })
    ];
    try {
      if (notify) notifyListeners();
    } catch (e) {
      //
    }
  }

  void removeLaptopMessage(String id) {
    _laptopMessages.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
