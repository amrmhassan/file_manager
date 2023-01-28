import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:flutter/cupertino.dart';

class ClientProvider extends ChangeNotifier {
  //? to send add client request
  Future addClient(
    String connLink,
    ShareProvider shareProvider,
    ServerProvider serverProvider,
    BuildContext context,
  ) async {
    await serverProvider.openServer(shareProvider);
    String deviceID = shareProvider.myDeviceId;
    String name = 'Client Name';
    String myIp = serverProvider.myIp!;
    int myPort = serverProvider.myPort;
    await Dio().get(
      '$connLink$addClientEndPoint',
      options: Options(
        headers: {
          nameString: name,
          deviceIDString: deviceID,
          portString: myPort,
          ipString: myIp,
        },
      ),
    );
  }

  //? to send a client left request
  Future unsubscribeClient(
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) async {
    PeerModel me = serverProvider.me(shareProvider);
    for (var peer in serverProvider.peers) {
      if (peer.sessionID == me.sessionID) continue;
      await Dio().get(
        '${getConnLink(peer.ip, peer.port)}$clientLeftEndPoint',
        options: Options(
          headers: {
            sessionIDString: me.sessionID,
          },
        ),
      );
    }
  }

  //? get a peer share space
  Future<List<ShareSpaceItemModel>> getPeerShareSpace(
    String sessionID,
    ServerProvider serverProvider,
    ShareProvider shareProvider,
  ) async {
    PeerModel peerModel = serverProvider.peerModelWithSessionID(sessionID);
    String connLink = getConnLink(peerModel.ip, peerModel.port);
    var res = await Dio().get('$connLink$getShareSpaceEndPoint');
    var data = res.data;
    List<ShareSpaceItemModel> items =
        (data as List).map((e) => ShareSpaceItemModel.fromJSON(e)).toList();
    return items;
  }

  //? to broadcast file removal from share space
  Future<void> broadCastFileRemovalFromShareSpace({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
    required List<String> paths,
  }) async {
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
      },
      data: paths,
    );
  }

  //? to broadcast file added to share space
  Future<void> broadCastFileAddedToShareSpace({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
    required List<ShareSpaceItemModel> addedItems,
  }) async {
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
      },
      data: addedItems.map((e) => e.toJSON()).toList(),
    );
  }

//? to broadcast data to all servers except me
  Future<void> _broadcast({
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
    required String endPoint,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    if (serverProvider.myIp == null) {
      return printOnDebug('you  aren\'t connected to make broadcast');
    }
    Iterable<PeerModel> allPeersButMe = serverProvider.allPeersButMe;
    for (var peer in allPeersButMe) {
      String remoteLink = '${peer.connLink}$endPoint';
      await Dio()
          .post(remoteLink, data: data, options: Options(headers: headers));
    }
  }
}
