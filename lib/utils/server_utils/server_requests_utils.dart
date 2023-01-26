// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';
import 'package:flutter/cupertino.dart';

//? used
enum HttpMethod {
  GET,
  POST,
  DELETE,
  UNKNOWN,
}

//? to convert the method string from the request object to enum
HttpMethod stringToHttpMethod(String m) {
  if (m == 'GET') {
    return HttpMethod.GET;
  } else if (m == 'POST') {
    return HttpMethod.POST;
  } else if (m == 'DELETE') {
    return HttpMethod.DELETE;
  } else {
    return HttpMethod.UNKNOWN;
  }
}

String jsonify(Map<String, dynamic> obj) {
  return json.encode(obj);
}

//? this will add the server routers(end points)
CustomRouterSystem addServerRouters(
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) {
  CustomRouterSystem customRouterSystem = CustomRouterSystem();
  customRouterSystem
    //? a new client added
    ..addRouter(addClientEndPoint, HttpMethod.GET, (request, response) async {
      var headers = request.headers;
      String name = headers.value(nameString) as String;
      String deviceID = headers.value(deviceIDString) as String;
      String ip = headers.value(ipString) as String;
      int port = int.parse(headers.value(portString) as String);
      PeerModel peerModel = serverProvider.addPeer(deviceID, name, ip, port);
      response
        ..headers.contentType = ContentType.json
        ..write(
          jsonify(peerModel.toJSON()),
        );
      await peerAdded(serverProvider);
    })
    //? to get the share space
    ..addRouter(getShareSpaceEndPoint, HttpMethod.GET, (request, response) {
      List<Map<String, String>> sharedItemsMap = shareProvider.sharedItems
          .map((e) => {
                pathHeaderKey: e.path,
                entityTypeHeaderKey: e.entityType.toString(),
                ownerIDHeaderKey: e.ownerID,
              })
          .toList();
      String jsonResponse = json.encode(sharedItemsMap);
      response
        ..headers.contentType = ContentType.json
        ..write(jsonResponse);
    })
    ..addRouter(clientAddedEndPoint, HttpMethod.GET, (request, response) {
      String newPeersJson = request.headers.value(newPeersHeaderKey)!;
      List<PeerModel> listOfAllPeers = (json.decode(newPeersJson) as List)
          .map(
            (e) => PeerModel.fromJSON(e),
          )
          .toList();
      serverProvider.updateAllPeers(listOfAllPeers);
    });
  return customRouterSystem;
}
