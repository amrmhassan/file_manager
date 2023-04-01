// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/utils/client_utils.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/websocket_utils/custom_client_socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:localization/localization.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:explorer/utils/connect_laptop_utils/handlers/connect_laptop_router.dart';

class ConnectLaptopProvider extends ChangeNotifier {
  int myPort = 0;
  String? myIp;

  String? remoteIP;
  int? remotePort;
  String? laptopID;
  String? laptopName;

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
      //! open server here
      httpServer = await testingRunConnLaptopServerWithCustomServer();
      // httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);
      //! i need to empty the request object from it's info and pass them to the main isolate for the listener on the ConnLaptopServiceController, yo might need to extract the request body , path , method for the outside main isolate
      //! and you might need to warn the user before clicking the back button with the connect laptop server is open
      // CustomRouterSystem customRouterSystem = connectLaptopRouter();
      // httpServer!.listen(customRouterSystem.pipeline);
      myPort = httpServer!.port;

      foregroundServiceController.connPhoneServerStarted();
      //? when above code is success then set the needed stuff like port, other things
      // myPort = await ConnLaptopServiceController.openServer(myPort);

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
    foregroundServiceController.connPhoneServerStopped();
  }

  Future<bool> handleConnect(Object? code) async {
    if (code is! String) return false;
    String? ip = await _getWorkingIp(code);
    logger.i('Working Ip is $ip');
    if (ip == null) {
      await closeServer();
      return false;
    }
    String wsConnLink = (await Dio().get(getConnLink(
            remoteIP!, remotePort!, EndPoints.phoneWsServerConnLink)))
        .data;
    CustomClientSocket customClientSocket = CustomClientSocket(
      onServerDisconnected: () {
        logger.w('Laptop disconnected');
        fastSnackBar(msg: 'laptop-disconnected'.i18n());
        closeServer();
      },
    );
    customClientSocket.client(wsConnLink, null);
    ioWebSocketChannel = customClientSocket.clientChannel;
    myClientWsSink = customClientSocket.clientChannel.sink;

    //? getting laptop info, (id, name)
    try {
      laptopID = await getLaptopID(this);
      laptopName = await getLaptopName(this);
    } catch (e) {
      logger.e(e);
    }

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
  // List<LaptopMessageModel> _laptopMessages = [];

  // List<LaptopMessageModel> get laptopMessages => [..._laptopMessages.reversed];

  // List<LaptopMessageModel> get viewedLaptopMessages =>
  //     _laptopMessages.where((element) => element.viewed).toList();

  // List<LaptopMessageModel> get notViewedLaptopMessages =>
  //     _laptopMessages.where((element) => !element.viewed).toList();

  // void addLaptopMessage(String msg) {
  //   _laptopMessages.add(LaptopMessageModel(
  //     msg: msg,
  //     at: DateTime.now(),
  //     id: Uuid().v4(),
  //   ));
  //   notifyListeners();
  // }

  // void markAllMessagesAsViewed([bool notify = true]) {
  //   _laptopMessages = [
  //     ..._laptopMessages.map((e) {
  //       e.viewed = true;
  //       return e;
  //     })
  //   ];
  //   try {
  //     if (notify) notifyListeners();
  //   } catch (e) {
  //     //
  //   }
  // }

  // void removeLaptopMessage(String id) {
  //   _laptopMessages.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }
}
