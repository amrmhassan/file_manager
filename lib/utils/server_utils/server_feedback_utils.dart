//? this will handle the server broadcasting to every device in the room or just one device
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:explorer/providers/server_provider.dart';

//? to broad cast that a new peer added then send all peers connected data
Future<void> peerAdded(ServerProvider serverProvider) async {
  for (var peer in serverProvider.peers) {
    //? to skip if the peer is me
    if (peer.ip == serverProvider.myIp) continue;
    String connLink = 'http://${peer.ip}:${peer.port}/clientAdded';
    await Dio().get(
      connLink,
      options: Options(
        headers: {
          'newPeers': json.encode(serverProvider.peers
              .map(
                (e) => e.toJSON(),
              )
              .toList())
        },
      ),
    );
  }
}
