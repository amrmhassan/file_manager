// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';

import 'package:explorer/models/white_block_list_model.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
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
  CustomServerSocket? customServerSocket;

  late MemberType myType;
  HttpServer? wsServer;

  List<WhiteBlockListModel> allowedPeers = [];
  List<WhiteBlockListModel> blockedPeers = [];

  bool ifPeerConnected(String ip, int port) {
    return (peers.any((element) => element.port == port && element.ip == ip));
  }

  void setMyIpAsClient(String ip) {
    myIp = ip;
    notifyListeners();
  }

  void firstConnected(
    String myIp,
    ShareProvider shareProvider,
    MemberType memberType,
  ) {
    this.myIp = myIp;
    // then add a client
    addMyPeerModel(myIp, shareProvider, memberType);
  }

  void addMyPeerModel(
    String ip,
    ShareProvider shareProvider,
    MemberType memberType,
  ) {
    PeerModel meHost = PeerModel(
      deviceID: shareProvider.myDeviceId,
      joinedAt: DateTime.now(),
      name: shareProvider.myName,
      memberType: memberType,
      ip: ip,
      port: myPort,
      sessionID: Uuid().v4(),
    );
    peers.add(meHost);
    notifyListeners();
  }

  Future<void> removeFromAllowedDevices(String deviceID) async {
    allowedPeers.removeWhere((element) => element.deviceID == deviceID);
    notifyListeners();
    Box allowedBox = await HiveBox.allowedDevices;
    await allowedBox.delete(deviceID);
  }

  Future<void> removeFromBlockedDevices(String deviceID) async {
    blockedPeers.removeWhere((element) => element.deviceID == deviceID);
    notifyListeners();
    Box blockedBox = await HiveBox.blockedDevices;
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
      Box allowedBox = await HiveBox.allowedDevices;
      await allowedBox.put(deviceID, model);
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
      Box blockedBox = await HiveBox.blockedDevices;
      await blockedBox.put(deviceID, model);
    }
  }

  Future<bool> isPeerAllowed(String deviceID) async {
    bool stateAllowed =
        allowedPeers.any((element) => element.deviceID == deviceID);
    if (stateAllowed) return true;

    Box allowedBox = await HiveBox.allowedDevices;
    bool dbAllowed = allowedBox.containsKey(deviceID);

    if (dbAllowed) {
      allowedPeers.add(allowedBox.get(deviceID));
      return true;
    }
    return false;
  }

  Future<bool> isPeerBlocked(String deviceID) async {
    bool stateBlocked =
        blockedPeers.any((element) => element.deviceID == deviceID);
    if (stateBlocked) return true;

    Box blockedBox = await HiveBox.blockedDevices;
    bool dbBlocked = blockedBox.containsKey(deviceID);
    if (dbBlocked) {
      blockedPeers.add(blockedBox.get(deviceID));
      return true;
    }

    return false;
  }

  bool connectedToDeviceWithId(String deviceID) {
    return peers.any((element) => element.deviceID == deviceID);
  }

  void setMyWsChannel(WebSocketSink s) {
    logger.i('setting ws sink (WebSocketSink) variable');
    myClientWsSink = s;
    notifyListeners();
  }

  void setMyServerSocket(CustomServerSocket s) {
    logger.i('setting ws server (CustomServerSocket) variable');
    customServerSocket = s;
    notifyListeners();
  }

  void setMyWSConnLink(String wsLink) {
    logger.i('setting ws conn link');
    myWSConnLink = wsLink;
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
    logger.i("peer $sessionID left");
    peers.removeWhere((element) => element.sessionID == sessionID);
    notifyListeners();
  }

  Future<void> closeWsServer() async {
    logger.i('Closing ws Server');
    await customServerSocket?.sendCloseMsg();
    await wsServer?.close();
  }

  Future<void> kickOutPeer(String ip, BuildContext context) async {
    showSnackBar(context: context, message: "soon");
  }

  //? send file
  Future<void> openServer(
    ShareProvider shareProvider,
    MemberType memberType,
    ShareItemsExplorerProvider shareItemsExplorerProvider,
  ) async {
    try {
      await closeServer();
      var myPossibleIPs = await getPossibleIpAddress();
      if (myPossibleIPs == null || myPossibleIPs.isEmpty) {
        logger.e('You are not connected to any network!');
        throw CustomException(
          e: 'You are not connected to any network!',
          s: StackTrace.current,
          rethrowError: true,
        );
      }
      //? opening the server port and setting end points
      logger.i('Opening server');
      // httpServer = await HttpServer.bind(InternetAddress.anyIPv4, myPort);

      // CustomRouterSystem customRouterSystem =
      //     addServerRouters(this, shareProvider, shareItemsExplorerProvider);
      httpServer = await testingRunServerWithCustomServer(
        this,
        shareProvider,
        shareItemsExplorerProvider,
      );
      logger.i('Http Server listening on ${httpServer?.port}');
      // httpServer!.listen(customRouterSystem.pipeline);
      //? when above code is success then set the needed stuff like port, other things
      myPort = httpServer!.port;
      myType = memberType;
      myConnLink = connLinkQrFromIterable(myPossibleIPs, myPort);

      notifyListeners();
    } catch (e) {
      logger.e(e);
      await closeServer();
      rethrow;
    }
  }

  //? to close the server
  Future closeServer() async {
    if (httpServer != null) {
      logger.i('Closing normal http server');
    }
    await httpServer?.close();
    httpServer = null;
    peers.clear();
    allowedPeers.clear();
    blockedPeers.clear();
    myConnLink = null;
    myIp = null;
    myPort = 0;
    notifyListeners();
    foregroundServiceController.shareSpaceServerStopped();
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
