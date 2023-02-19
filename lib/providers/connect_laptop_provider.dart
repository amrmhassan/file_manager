// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/laptop_message_model.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/simple_encryption_utils/simple_encryption_utils.dart';
import 'package:explorer/utils/websocket_utils/custom_client_socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

class ConnectLaptopProvider extends ChangeNotifier {
  int myPort = 0;
  String? myIp;
  String? remoteIP;
  int? remotePort;
  HttpServer? httpServer;
  IOWebSocketChannel? ioWebSocketChannel;

  late HttpServer wsServer;

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
      await _closeServer();

      //? opening the server port and setting end points
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);

      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;

      CustomRouterSystem customRouterSystem = connectLaptopRouter(this);
      httpServer!.listen(customRouterSystem.pipeline);

      notifyListeners();
    } catch (e) {
      await _closeServer();
      rethrow;
    }
  }

  //? to close the server
  Future _closeServer() async {
    logger.i('Closing normal http server');
    await httpServer?.close();
    httpServer = null;
    myIp = null;
    remoteIP = null;
    remotePort = null;
    myPort = 0;
    ioWebSocketChannel = null;
    notifyListeners();
  }

  Future<bool> handleConnect(Object? code) async {
    if (code is! String) return false;
    String? ip = await _getWorkingIp(code);
    logger.i('Working Ip is $ip');
    if (ip == null) {
      await _closeServer();
      return false;
    }
    String wsConnLink = (await Dio().get(
            getConnLink(remoteIP!, remotePort!, phoneWsServerConnLinkEndPoint)))
        .data;
    CustomClientSocket customClientSocket = CustomClientSocket(
      onServerDisconnected: () {
        logger.w('Laptop disconnected');
        _closeServer();
      },
    );
    customClientSocket.client(wsConnLink, null);
    ioWebSocketChannel = customClientSocket.clientChannel;
    notifyListeners();
    return true;
  }

  Future<String?> _getWorkingIp(String code) async {
    String decrypted = SimpleEncryption(code).decrypt();
    var data = decrypted.split('||');
    int port = int.parse(data.last);
    var ips = data.first.split('|');
    Completer<String?> completer = Completer<String?>();
    await _openServer();

    Dio dio = Dio();
    // dio.options.sendTimeout = 2000;
    // dio.options.connectTimeout = 2000;
    // dio.options.receiveTimeout = 2000;

    for (var ip in ips) {
      dio
          .post(
        getConnLink(ip, port, serverCheckEndPoint),
        data: myPort,
      )
          .then((data) {
        _connected(data.data, ip, port);

        if (!completer.isCompleted) {
          completer.complete(ip);
        }
      }).catchError((error) {
        int index = ips.toList().indexOf(ip);
        if (index == ips.length - 1) {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        }
      });
    }
    return completer.future;
  }

  //# message that will come from the laptop
  List<LaptopMessageModel> laptopMessages = [];
  bool messagesViewed = false;

  List<LaptopMessageModel> get viewedLaptopMessages =>
      laptopMessages.where((element) => element.viewed).toList();

  List<LaptopMessageModel> get notViewedLaptopMessages =>
      laptopMessages.where((element) => !element.viewed).toList();

  void addLaptopMessage(String msg) {
    laptopMessages.add(LaptopMessageModel(
      msg: msg,
      at: DateTime.now(),
      id: Uuid().v4(),
    ));
    notifyListeners();
  }

  void markAllMessagesAsViewed() {
    laptopMessages = [
      ...laptopMessages.map((e) {
        e.viewed = true;
        return e;
      })
    ];
    try {
      notifyListeners();
    } catch (e) {
      //
    }
  }

  void removeLaptopMessage(String id) {
    laptopMessages.where((element) => element.id == id);
    notifyListeners();
  }
}
