// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/beacon_client.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/utils/beacon_server_utils.dart/beacon_server.dart';
import 'package:explorer/utils/client_utils.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

// the beacon server will allow everyone to view his image and name with no protection
// but for getting the server connLink a modal will be shown on the beacon server device to ask the user to allow another one to access
// his server, this is just to replace or to work aside with qr code scanner
class BeaconProvider extends ChangeNotifier {
  //# for beacon client
  bool _cleared = false;
  // this is the url of the beacon server that was clicked and i am waiting for his response
  String? beaconServerUnderRequest;

  final List<BeaconServerModel> _discoveredBeaconServers = [];
  List<BeaconServerModel> get discoveredBeaconServers =>
      [..._discoveredBeaconServers];

  void _addBeaconServer(
    String serverName,
    String url,
    ServerProvider serverProvider,
    String id,
  ) {
    String? myServerID = serverProvider.beaconServer?.serverID;
    if (myServerID == id && kReleaseMode) return;
    // to return if the server is discovered once by, another interface
    if (_discoveredBeaconServers.any((element) => element.url == url)) return;
    // i want to return if the discovered beacon server url is my beacon server url
    BeaconServerModel discoveredOne = BeaconServerModel(
      deviceName: serverName,
      url: url,
      id: id,
    );
    _discoveredBeaconServers.add(discoveredOne);
    notifyListeners();
  }

  void _setABeaconServerImage(String url, Uint8List? image) {
    int index =
        _discoveredBeaconServers.indexWhere((element) => element.url == url);
    if (index == -1) return;
    BeaconServerModel model = _discoveredBeaconServers[index];
    model.serverImage = image;
    if (image == null) {
      model.noImage = true;
    }
    _discoveredBeaconServers[index] = model;

    notifyListeners();
  }

  void _setABeaconServerConnLink(String url, String connLink) {
    int index =
        _discoveredBeaconServers.indexWhere((element) => element.url == url);
    BeaconServerModel model = _discoveredBeaconServers[index];
    model.connQueryLink = connLink;

    _discoveredBeaconServers[index] = model;

    notifyListeners();
  }

  void startScanForBeaconServers(
    ServerProvider serverProvider,
    BuildContext context,
  ) async {
    _cleared = false;
    _discoveredBeaconServers.clear();
    beaconServerUnderRequest = null;
    notifyListeners();
    DateTime start = DateTime.now();
    while (context.mounted) {
      await BeaconServer.getWorkingDevice(
        onDeviceFound: (
          url,
          name,
          id,
        ) {
          //? to prevent adding a new beacon server if cleared
          if (_cleared) return;
          _addBeaconServer(
            name,
            url,
            serverProvider,
            id,
          );
        },
        onHostError: (url) {
          int index = _discoveredBeaconServers
              .indexWhere((element) => element.url == url);
          if (index == -1) return;
          _discoveredBeaconServers.removeAt(index);
          notifyListeners();
        },
      );

      await Future.delayed(Duration(milliseconds: 500));
    }

    DateTime end = DateTime.now();
    logger.i('scan time took ${end.difference(start).inMilliseconds}ms');

    notifyListeners();
  }

  Future<void> askForBeaconServerConnLink({
    required String myName,
    required String myDeviceID,
    required String beaconServerUrl,
  }) async {
    bool repeatedRequest = false;
    try {
      if (beaconServerUnderRequest != null) {
        repeatedRequest = true;
        throw CustomException(e: 'wait-for-host'.i18n());
      }
      beaconServerUnderRequest = beaconServerUrl;
      // this might throw an error, so handle it from the UI
      var data = await Dio().get(
        '$beaconServerUrl${EndPoints.getBeaconServerConnLink}',
        options: Options(
          headers: {
            KHeaders.userNameHeaderKey: myName,
            KHeaders.deviceIDHeaderKey: myDeviceID,
          },
        ),
      );
      beaconServerUnderRequest = null;

      //! here you need to set the beacon server connLink to the provider
      //? this will show a modal that you are waiting for the beacon server to accept your request to join
      _setABeaconServerConnLink(beaconServerUrl, data.data);
    } catch (e) {
      if (!repeatedRequest) {
        beaconServerUnderRequest = null;
      }
      rethrow;
    }
  }

  void askForBeaconServerImage({
    required String beaconServerUrl,
  }) async {
    var beaconServer = _discoveredBeaconServers
        .firstWhere((element) => element.url == beaconServerUrl);
    if (beaconServer.serverImage != null) return;

    try {
      Uint8List? image = await getPeerImage(beaconServerUrl);
      _setABeaconServerImage(beaconServerUrl, image);
    } catch (e) {
      _setABeaconServerImage(beaconServerUrl, null);
      logger.i('this beacon server doesnt have an image');
    }
  }

  // void clearBeaconServers() {
  //! this cleared method will be called when the scanning screen is popped
  // _discoveredBeaconServers.clear();
  // _cleared = true;
  // notifyListeners();
  // }

  //# for beacon server
  List<BeaconClient> beaconClients = [];
}
