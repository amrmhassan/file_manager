// ignore_for_file: constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/server_utils/custom_router_system.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';

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
  ShareItemsExplorerProvider shareItemsExplorerProvider,
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
      List<Map<String, String?>> sharedItemsMap =
          shareProvider.sharedItems.map((e) {
        ShareSpaceItemModel shareSpaceItemModel = e;
        shareSpaceItemModel.ownerSessionID =
            serverProvider.me(shareProvider).sessionID;
        return shareSpaceItemModel.toJSON();
      }).toList();
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
    })
    ..addRouter(clientLeftEndPoint, HttpMethod.GET, (request, response) {
      String sessionID = request.headers.value(sessionIDString)!;
      serverProvider.peerLeft(sessionID);
    })
    ..addRouter(fileAddedToShareSpaceEndPoint, HttpMethod.POST,
        (request, response) async {
      //! i am stuck here
      //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
      var headers = request.headers;
      var senderSessionID = (headers[ownerSessionIDString])!.first;

      Uint8List bodyBinary = await request.single;
      String bodyString = utf8.decode(bodyBinary);
      List<dynamic> bodyJson = json.decode(bodyString);
      List<ShareSpaceItemModel> addedItemsModels = bodyJson.map((e) {
        ShareSpaceItemModel s = ShareSpaceItemModel.fromJSON(e);
        s.ownerSessionID = senderSessionID;
        return s;
      }).toList();
      print(addedItemsModels.first.path);

      shareItemsExplorerProvider.addToPeerShareSpaceScreen(
        addedItems: addedItemsModels,
        sessionId: senderSessionID,
      );

      // print(headers);
    })
    ..addRouter(fileRemovedFromShareSpaceEndPoint, HttpMethod.POST,
        (request, response) async {
      //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
      Uint8List bodyBinary = await request.single;
      String bodyString = utf8.decode(bodyBinary);
      List<dynamic> bodyJson = json.decode(bodyString);
      List<String> removedItemsPaths =
          bodyJson.map((e) => e as String).toList();
      var headers = request.headers;
      var senderSessionID = (headers[ownerSessionIDString])!.first;
      print(removedItemsPaths.first);

      shareItemsExplorerProvider.removeFromPeerShareSpace(
          removedItems: removedItemsPaths, sessionId: senderSessionID);
    });
  return customRouterSystem;
}
