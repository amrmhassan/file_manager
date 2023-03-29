// ignore_for_file: prefer_const_constructors

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/utils/beacon_server_utils.dart/beacon_server.dart';
import 'package:flutter/material.dart';

// the beacon server will allow everyone to view his image and name with no protection
// but for getting the server connLink a modal will be shown on the beacon server device to ask the user to allow another one to access
// his server, this is just to replace or to work aside with qr code scanner
class BeaconProvider extends ChangeNotifier {
  bool _scanning = false;
  bool get scanning => _scanning;
  bool _cleared = false;

  final List<BeaconServerModel> _discoveredBeaconServers = [];
  List<BeaconServerModel> get discoveredBeaconServers =>
      [..._discoveredBeaconServers];

  void _addBeaconServer(
    String serverName,
    String url,
    ServerProvider serverProvider,
  ) {
    // to return if the server is discovered once by, another interface
    if (_discoveredBeaconServers.any((element) => element.url == url)) return;
    // i want to return if the discovered beacon server url is my beacon server url
    BeaconServerModel discoveredOne = BeaconServerModel(
      deviceName: serverName,
      url: url,
    );
    _discoveredBeaconServers.add(discoveredOne);
    notifyListeners();
  }

  void setABeaconServerImage(String url, Uint8List image) {
    int index =
        _discoveredBeaconServers.indexWhere((element) => element.url == url);
    BeaconServerModel model = _discoveredBeaconServers[index];
    model.serverImage = image;
    _discoveredBeaconServers[index] = model;
    notifyListeners();
  }

  void startScanForBeaconServers(
    ServerProvider serverProvider,
  ) async {
    if (_scanning) return;
    _scanning = true;
    _cleared = false;
    notifyListeners();
    await BeaconServer.getWorkingDevice(
      onDeviceFound: (url, name) {
        //? to prevent adding a new beacon server if cleared
        if (_cleared) return;
        _addBeaconServer(
          name,
          url,
          serverProvider,
        );
      },
    );
    _scanning = false;
    notifyListeners();
  }

  Future<String> askForBeaconServerConnLink({
    required String id,
    required String myName,
    required String myDeviceID,
    required String beaconServerUrl,
  }) async {
    // this might throw an error, so handle it from the UI
    var data = await Dio().get('$beaconServerUrl/${EndPoints.getMyConnLink}');
    //! here you need to set the beacon server connLink to the provider
    //? this will show a modal that you are waiting for the beacon server to accept your request to join

    return data.data;
  }

  Future<String> askForBeaconServerImage({
    required String beaconServerUrl,
  }) async {
    var data =
        await Dio().get('$beaconServerUrl/${EndPoints.getPeerImagePath}');
    //! here you need to set the beacon server image to the provider

    return data.data;
  }

  void clearBeaconServers() {
    //! this cleared method will be called when the scanning screen is popped
    _discoveredBeaconServers.clear();
    _cleared = true;
    notifyListeners();
  }
}
