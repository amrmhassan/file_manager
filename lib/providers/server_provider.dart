// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/hive_constants.dart';
import 'package:explorer/helpers/hive_helper.dart';
import 'package:explorer/models/white_block_list_model.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/utils/custom_router_system/custom_router_system.dart';
import 'package:explorer/utils/server_utils/ip_utils.dart';
import 'package:explorer/utils/server_utils/handlers/router.dart';
import 'package:explorer/utils/websocket_utils/custom_server_socket.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/peer_model.dart';

//? when adding a new client the client can be added by any of the other clients and the adding client will send a broadcast to all other devices in the network about the new client
//? for example, adding a new client will be at /addclient and when the client is added in one of the connected devices that device will send a message to every other device in the network with /clientAdded with the new list of the clients in the network
//? including the new device which will add the clients list to his state to be used later

class ServerProvider extends ChangeNotifier {
  String? myConnLink;
  late String myWSConnLink;
  int myPort = 0;
  String? myIp;
  HttpServer? httpServer;
  List<PeerModel> peers = [];
  late WebSocketSink myClientWsSink;
  late CustomServerSocket customServerSocket;
  bool hostWithWifi = false;

  late MemberType myType;
  late HttpServer wsServer;

  List<WhiteBlockListModel> allowedPeers = [];
  List<WhiteBlockListModel> blockedPeers = [];

  Future<void> removeFromAllowedDevices(String deviceID) async {
    allowedPeers.removeWhere((element) => element.deviceID == deviceID);
    notifyListeners();
    Box allowedBox = await HiveHelper(allowedDevicesBoxName).init();
    await allowedBox.delete(deviceID);
  }

  Future<void> removeFromBlockedDevices(String deviceID) async {
    blockedPeers.removeWhere((element) => element.deviceID == deviceID);
    notifyListeners();
    Box blockedBox = await HiveHelper(blockedDevicesBoxName).init();
    await blockedBox.delete(deviceID);
  }

  Future<void> allowDevice(String deviceID, bool remember) async {
    var model = WhiteBlockListModel(
      deviceID: deviceID,
      name: peerModelWithDeviceID(deviceID).name,
    );
    allowedPeers.add(model);
    notifyListeners();
    if (remember) {
      //! save if remember
      Box allowedBox = await HiveHelper(allowedDevicesBoxName).init();
      await allowedBox.put(deviceID, model.toJSON());
    }
  }

  Future<void> blockDevice(
    String deviceID,
    bool remember, [
    bool justOneTime = false,
  ]) async {
    if (justOneTime) return;
    var model = WhiteBlockListModel(
      deviceID: deviceID,
      name: peerModelWithDeviceID(deviceID).name,
    );
    blockedPeers.add(model);
    notifyListeners();
    if (remember) {
      //! save if remember
      Box blockedBox = await HiveHelper(blockedDevicesBoxName).init();
      await blockedBox.put(deviceID, model.toJSON());
    }
  }

  Future<bool> isPeerAllowed(String deviceID) async {
    bool stateAllowed =
        allowedPeers.any((element) => element.deviceID == deviceID);
    if (stateAllowed) return true;

    Box allowedBox = await HiveHelper(allowedDevicesBoxName).init();
    bool dbAllowed = allowedBox.containsKey(deviceID);

    if (dbAllowed) {
      allowedPeers.add(WhiteBlockListModel.fromJSON(allowedBox.get(deviceID)));
      return true;
    }
    return false;
  }

  Future<bool> isPeerBlocked(String deviceID) async {
    bool stateBlocked =
        blockedPeers.any((element) => element.deviceID == deviceID);
    if (stateBlocked) return true;

    Box blockedBox = await HiveHelper(blockedDevicesBoxName).init();
    bool dbBlocked = blockedBox.containsKey(deviceID);
    if (dbBlocked) {
      blockedPeers.add(WhiteBlockListModel.fromJSON(blockedBox.get(deviceID)));
      return true;
    }

    return false;
  }

  bool connectedToDeviceWithId(String deviceID) {
    return peers.any((element) => element.deviceID == deviceID);
  }

  void setMyWsChannel(WebSocketSink s) {
    myClientWsSink = s;
    notifyListeners();
  }

  void setMyServerSocket(CustomServerSocket s) {
    customServerSocket = s;
    notifyListeners();
  }

//? get the host peer
  PeerModel? get getHostPeer {
    try {
      return peers
          .firstWhere((element) => element.memberType == MemberType.host);
    } catch (e) {
      return null;
    }
  }

  //? all peers but me
  Iterable<PeerModel> get allPeersButMe =>
      peers.where((element) => element.ip != myIp);

  //? to return my info
  PeerModel me(ShareProvider shareProvider) {
    return peers
        .firstWhere((element) => element.deviceID == shareProvider.myDeviceId);
  }

  //?
  PeerModel peerModelWithSessionID(String sessionID) {
    return peers.firstWhere((element) => element.sessionID == sessionID);
  }

  PeerModel peerModelWithDeviceID(String deviceID) {
    return peers.firstWhere((element) => element.deviceID == deviceID);
  }

  //? update all peers
  void updateAllPeers(List<PeerModel> newPeersList) {
    peers = [...newPeersList];
    notifyListeners();
  }

  //? remove peer
  void peerLeft(String sessionID) {
    peers.removeWhere((element) => element.sessionID == sessionID);
    notifyListeners();
  }

  Future<void> closeWsServer() async {
    logger.i('Closing ws Server');
    await customServerSocket.sendCloseMsg();
    await wsServer.close();
  }

  //? send file
  Future<void> openServer(
    ShareProvider shareProvider,
    MemberType memberType,
    ShareItemsExplorerProvider shareItemsExplorerProvider, [
    bool wifi = true,
  ]) async {
    //! host device must always be hotspot or wifi
    //! client device must always be wifi
    hostWithWifi = wifi;
    // notifyListeners();
    try {
      String? myWifiIp = await getMyIpAddress(wifi);
      if (myWifiIp == null) {
        throw CustomException(
          e: wifi ? 'No Connected' : 'Open Your HotSpot please',
          s: StackTrace.current,
          rethrowError: true,
        );
      }
      //? opening the server port and setting end points
      httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);
      if (memberType == MemberType.host) {
        customServerSocket = CustomServerSocket(myWifiIp, this, shareProvider);
        wsServer = await customServerSocket.getWsConnLink();
        myWSConnLink = getConnLink(myWifiIp, wsServer.port, true);
      }

      CustomRouterSystem customRouterSystem =
          addServerRouters(this, shareProvider, shareItemsExplorerProvider);
      httpServer!.listen(customRouterSystem.pipeline);
      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;
      myType = memberType;
      myIp = myWifiIp;
      myConnLink = 'http://$myWifiIp:$myPort';

      PeerModel meHost = PeerModel(
        deviceID: shareProvider.myDeviceId,
        joinedAt: DateTime.now(),
        name: shareProvider.myName,
        memberType: memberType,
        ip: myIp!,
        port: myPort,
        sessionID: Uuid().v4(),
      );
      peers.add(meHost);
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
    peers.clear();
    allowedPeers.clear();
    blockedPeers.clear();
    myConnLink = null;
    myIp = null;
    notifyListeners();
  }

  //? to restart the server
  Future restartServer(
    ShareProvider shareProvider,
    ShareItemsExplorerProvider shareItemsExplorerProvider,
  ) async {
    await httpServer?.close();
    await openServer(shareProvider, myType, shareItemsExplorerProvider);
  }

  //# server functions
  PeerModel addPeer(
      String sessionID, String clientId, String name, String ip, int port) {
    // if the peer is already registered
    // this might mean that he disconnected
    // so i will replace the current session with the new one
    bool exists = peers.any((element) => element.deviceID == clientId);
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

  //?
  void addPeerFromModel(PeerModel peerModel) {
    peers.add(peerModel);
    notifyListeners();
  }

  //? this will be used when a new device is connected
  void broadcastToAllClients() {
    //? here i will send a normal http request to all clients from the peers except me of course
    //? this should run only from the server(hotspot) device and it will be only one such a device in the network
  }

  //? when an item is added to share space the adding device will send a message to all connected devices to him
}
