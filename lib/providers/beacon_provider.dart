// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:explorer/models/beacon_server_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// the beacon server will allow everyone to view his image and name with no protection
// but for getting the server connLink a modal will be shown on the beacon server device to ask the user to allow another one to access
// his server, this is just to replace or to work aside with qr code scanner
class BeaconProvider extends ChangeNotifier {
  final List<BeaconServerModel> _discoveredBeaconServers = [];
  List<BeaconServerModel> get discoveredBeaconServers =>
      [..._discoveredBeaconServers];

  void addBeaconServer(String serverName) {
    BeaconServerModel discoveredOne = BeaconServerModel(
      id: Uuid().v4(),
      deviceName: serverName,
    );
    _discoveredBeaconServers.add(discoveredOne);
    notifyListeners();
  }

  void setABeaconServerImage(String id, Uint8List image) {
    int index =
        _discoveredBeaconServers.indexWhere((element) => element.id == id);
    BeaconServerModel model = _discoveredBeaconServers[index];
    model.serverImage = image;
    _discoveredBeaconServers[index] = model;
    notifyListeners();
  }

  void askForBeaconServerConnLink(String id) async {
    // this will be called when clicking a beacon server icon on the client screen
    // and when clicked a request will be sent to the beacon server to ask for his connLink
  }
}
