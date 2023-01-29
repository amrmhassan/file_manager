import 'dart:convert';
import 'dart:io';

import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/server_utils/server_feedback_utils.dart';
import 'package:explorer/utils/server_utils/server_requests_utils.dart';
import 'package:flutter/foundation.dart';

void addClientMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) async {
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
}

void getShareSpaceMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) {
  List<Map<String, dynamic>> sharedItemsMap =
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
}

void clientAddedMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) {
  String newPeersJson = request.headers.value(newPeersHeaderKey)!;
  List<PeerModel> listOfAllPeers = (json.decode(newPeersJson) as List)
      .map(
        (e) => PeerModel.fromJSON(e),
      )
      .toList();
  serverProvider.updateAllPeers(listOfAllPeers);
}

void clientLeftMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
) {
  String sessionID = request.headers.value(sessionIDString)!;
  serverProvider.peerLeft(sessionID);
}

void fileAddedMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  //! i am stuck here
  //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
  var headers = request.headers;
  var senderSessionID = (headers[ownerSessionIDString])!.first;

  String bodyString = await decodeRequest(request);
  List<dynamic> bodyJson = json.decode(bodyString);
  List<ShareSpaceItemModel> addedItemsModels = bodyJson.map((e) {
    ShareSpaceItemModel s = ShareSpaceItemModel.fromJSON(e);
    s.ownerSessionID = senderSessionID;
    return s;
  }).toList();

  shareItemsExplorerProvider.addToPeerShareSpaceScreen(
    addedItems: addedItemsModels,
    sessionId: senderSessionID,
  );

  // print(headers);
}

void fileRemovedMiddleWare(
  HttpRequest request,
  HttpResponse response,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  //? here make a provider to handle peer share space items then update the items if the viewed items are for the updated peer
  String bodyString = await decodeRequest(request);
  List<dynamic> bodyJson = json.decode(bodyString);
  List<String> removedItemsPaths = bodyJson.map((e) => e as String).toList();
  var headers = request.headers;
  var senderSessionID = (headers[ownerSessionIDString])!.first;

  shareItemsExplorerProvider.removeFromPeerShareSpace(
      removedItems: removedItemsPaths, sessionId: senderSessionID);
}

Future<void> getFolderContent(
  HttpRequest request,
  HttpResponse response,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
) async {
  var headers = request.headers;
  String folderPath = headers[folderPathHeaderKey]!.first;
  // i will need the peer session id to know that if it is allowed or not
  String peerSessionID = headers[sessionIDHeaderKey]!.first;
  Directory directory = Directory(folderPath);
  if (directory.existsSync()) {
    PeerModel me = serverProvider.me(shareProvider);
    var folderChildren = await compute(getFolderChildren, folderPath);
    List<Map<String, dynamic>> sharedItems = folderChildren.map((entity) {
      FileStat fileStat = entity.statSync();

      return ShareSpaceItemModel(
        blockedAt: [],
        entityType: fileStat.type == FileSystemEntityType.file
            ? EntityType.file
            : EntityType.folder,
        path: entity.path,
        ownerDeviceID: me.deviceID,
        ownerSessionID: me.sessionID,
        addedAt: DateTime.now(),
        size: fileStat.size,
      ).toJSON();
    }).toList();
    var encodedData = utf8.encode(json.encode(sharedItems));

    response
      ..headers.add('Content-Type', 'application/json; charset=utf-8')
      ..add(encodedData);
  }
}

// the isolate that will get any folder children then return it when finished
List<FileSystemEntity> getFolderChildren(String folderPath) {
  return Directory(folderPath).listSync();
}
