import 'dart:io';
import 'dart:typed_data';

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
import 'package:explorer/utils/websocket_utils/custom_client_socket.dart';

//! make a function to send utf8 requests and handles them on the server side by reading the utf8
//! and add the header
//! actually i just needed to handle the server side by decoding the utf8 request
//? to send add client request
Future addClient(
  String connLink,
  ShareProvider shareProvider,
  ServerProvider serverProviderFalse,
  ShareItemsExplorerProvider shareItemsExplorerProvider,
) async {
  try {
    String? mySessionID =
        await connectToWsServer(connLink, serverProviderFalse);
    if (mySessionID == null) {
      throw CustomException(
        e: 'My Session ID is null',
        s: StackTrace.current,
      );
    }
    await serverProviderFalse.openServer(
      shareProvider,
      MemberType.client,
      shareItemsExplorerProvider,
    );
    String deviceID = shareProvider.myDeviceId;
    String name = shareProvider.myName;
    String myIp = serverProviderFalse.myIp!;
    int myPort = serverProviderFalse.myPort;
    await Dio().post(
      '$connLink$addClientEndPoint',
      data: {
        nameString: name,
        deviceIDString: deviceID,
        portString: myPort,
        ipString: myIp,
        sessionIDString: mySessionID,
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

//?
// the user will ask for the other peer image then i will be headed to the other user handler asking for his image
// then if he has one he will reply with his one as a Uint8List
// otherwise he will reply with a 404 error which will cause this getPeerImage function to return null
//
Future<Uint8List?> getPeerImage(String connLink) async {
  try {
    String url = '$connLink$getPeerImagePathEndPoint';
    Uri uri = Uri.parse(url);
    HttpClient client = HttpClient();
    var request = await client.getUrl(uri);
    var res = await request.close();
    if (res.statusCode == 404) throw Exception('No image');
    List<int> bytes = [];
    await for (var chunk in res) {
      bytes.addAll(chunk);
    }

    return Uint8List.fromList(bytes);
  } catch (e) {
    return null;
  }
}

Future unsubscribeMe(ServerProvider serverProviderFalse) async {
  // if i left, this will tell the server about that
  // then the server will tell every one else about me
  //! here check if i am a client or a server
  //! if client just leave it as it is
  //! or close the server instead
  if (serverProviderFalse.myType == MemberType.client) {
    serverProviderFalse.myClientWsSink
        .close(null, 'user normally left the group');
  } else if (serverProviderFalse.myType == MemberType.host) {
    serverProviderFalse.closeWsServer();
  }
}

//? to send a client left request
Future broadcastUnsubscribeClient(
  ServerProvider serverProviderFalse,
  ShareProvider shareProviderFalse,
  String customSessionID,
) async {
  // this should be called from the server to notify all other clients that a device has been disconnected
  // with his session id to be removed from the group
  try {
    PeerModel me = serverProviderFalse.me(shareProviderFalse);
    List<PeerModel> peersCopied = [...serverProviderFalse.peers];
    for (var peer in peersCopied) {
      if (peer.sessionID == me.sessionID) continue;
      await Dio().post(
        '${getConnLink(peer.ip, peer.port)}$clientLeftEndPoint',
        data: {
          sessionIDString: customSessionID,
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
    var res = await Dio().get(
      connLink,
      options: Options(
        headers: {
          deviceIDHeaderKey: shareProvider.myDeviceId,
          userNameHeaderKey: shareProvider.myName,
        },
        receiveDataWhenStatusError: false,
      ),
    );
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
  } on DioError catch (e) {
    String? reason = e.response?.headers.value(serverRefuseReasonHeaderKey);
    throw CustomException(
      e: reason ?? 'Unknown Reason',
      s: StackTrace.current,
    );
  }
  shareItemsExplorerProvider.setLoadingItems(false);
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

//! check the method of addclient
//! i am calling openServer, debug if the client opens add a peer model with server name, and host or not
Future<String?> connectToWsServer(
  String connLink,
  ServerProvider serverProviderFalse,
) async {
  try {
    CustomClientSocket clientSocket = CustomClientSocket();
    String wsConnLink = (await Dio().get(
      '$connLink$wsServerConnLinkEndPoint',
    ))
        .data;

    clientSocket.client(wsConnLink, serverProviderFalse);
    String mySessionID = await clientSocket.getMySessionID();
    serverProviderFalse.setMyWsChannel(clientSocket.clientChannel.sink);
    return mySessionID;
  } catch (e, s) {
    throw CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}
