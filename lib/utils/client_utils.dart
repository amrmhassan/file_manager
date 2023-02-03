import 'dart:io';

import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:flutter/cupertino.dart';

//! make a function to send utf8 requests and handles them on the server side by reading the utf8
//! and add the header
//! actually i just needed to handle the server side by decoding the utf8 request
//? to send add client request
Future addClient(
  String connLink,
  ShareProvider shareProvider,
  ServerProvider serverProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
  BuildContext context,
) async {
  try {
    await serverProvider.openServer(shareProvider, shareItemsExplorerProvider);
    String deviceID = shareProvider.myDeviceId;
    String name = 'Client Name';
    String myIp = serverProvider.myIp!;
    int myPort = serverProvider.myPort;
    await Dio().post(
      '$connLink$addClientEndPoint',
      data: {
        nameString: name,
        deviceIDString: deviceID,
        portString: myPort,
        ipString: myIp,
      },
    );
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to send a client left request
Future unsubscribeClient(
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse, [
  String? customSessionID,
]) async {
  try {
    PeerModel me = serverProviderFalse.me(shareProviderFalse);
    List<PeerModel> peersCopied = [...serverProviderFalse.peers];
    for (var peer in peersCopied) {
      if (peer.sessionID == me.sessionID) continue;
      await Dio().post(
        '${getConnLink(peer.ip, peer.port)}$clientLeftEndPoint',
        data: {
          sessionIDString: customSessionID ?? me.sessionID,
        },
      );
    }
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? get a peer share space
Future<void> getPeerShareSpace(
  String sessionID,
  ServerProvider serverProvider,
  ShareProvider shareProvider,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
  String deviceID,
) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    PeerModel peerModel = serverProvider.peerModelWithSessionID(sessionID);
    String connLink = peerModel.getMyLink(getShareSpaceEndPoint);
    var res = await Dio().get(connLink);
    var data = res.data;
    List<ShareSpaceItemModel> items =
        (data as List).map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    shareItemsExplorerProvider.updateShareSpaceScreenInfo(
      viewedUserSessionId: sessionID,
      viewedUserDeviceId: deviceID,
      viewedItems: items,
      serverProvider: serverProvider,
      shareProvider: shareProvider,
    );
    shareItemsExplorerProvider.setLoadingItems(false);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to broadcast file removal from share space
Future<void> broadCastFileRemovalFromShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<String> paths,
}) async {
  try {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    PeerModel me = serverProvider.me(shareProvider);
    await _broadcast(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      endPoint: fileRemovedFromShareSpaceEndPoint,
      headers: {
        ownerSessionIDString: me.sessionID,
        ownerDeviceIDString: me.deviceID,
        // 'Content-Type': 'application/json; charset=utf-8',
      },
      data: paths,
    );
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to broadcast file added to share space
Future<void> broadCastFileAddedToShareSpace({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required List<ShareSpaceItemModel> addedItems,
}) async {
  try {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    PeerModel me = serverProvider.me(shareProvider);
    await _broadcast(
      serverProvider: serverProvider,
      shareProvider: shareProvider,
      endPoint: fileAddedToShareSpaceEndPoint,
      headers: {
        ownerSessionIDString: me.sessionID,
        ownerDeviceIDString: me.deviceID,
        // 'Content-Type': 'application/json; charset=utf-8',
      },
      data: addedItems.map((e) {
        e.size = File(e.path).statSync().size;
        return e.toJSON();
      }).toList(),
    );
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

Future<void> getFolderContent({
  required ServerProvider serverProvider,
  required String folderPath,
  required ShareProvider shareProvider,
  required String userSessionID,
  required ShareItemsExplorerProvider shareItemsExplorerProvider,
}) async {
  try {
    shareItemsExplorerProvider.setLoadingItems(true);
    PeerModel me = serverProvider.me(shareProvider);
    PeerModel otherPeer = serverProvider.peerModelWithSessionID(userSessionID);
    String connLink = getConnLink(otherPeer.ip, otherPeer.port);
    var res = await Dio().get(
      '$connLink$getFolderContentEndPointEndPoint',
      options: Options(
        headers: {
          folderPathHeaderKey: Uri.encodeComponent(folderPath),
          sessionIDHeaderKey: me.sessionID,
        },
      ),
    );
    var data = res.data as List;
    var items = data.map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    shareItemsExplorerProvider.updatePath(folderPath, items);

    shareItemsExplorerProvider.setLoadingItems(false, false);
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}

//? to broadcast data to all servers except me
Future<void> _broadcast({
  required ServerProvider serverProvider,
  required ShareProvider shareProvider,
  required String endPoint,
  Map<String, dynamic>? headers,
  dynamic data,
}) async {
  try {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    Iterable<PeerModel> allPeersButMe = serverProvider.allPeersButMe;
    for (var peer in allPeersButMe) {
      String remoteLink = '${peer.connLink}$endPoint';

      await Dio().post(
        remoteLink,
        data: data,
        options: Options(
          headers: headers,
          // requestEncoder: (request, options) {
          //   return utf8.encode(request);
          // },
        ),
      );
    }
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}
