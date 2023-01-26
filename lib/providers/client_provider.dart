import 'package:dio/dio.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
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
}
