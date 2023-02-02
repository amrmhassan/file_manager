//? this will handle the server broadcasting to every device in the room or just one device
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';

//? to broad cast that a new peer added then send all peers connected data
Future<void> peerAddedServerFeedBack(ServerProvider serverProvider) async {
  try {
    for (var peer in serverProvider.peers) {
      //? to skip if the peer is me
      if (peer.ip == serverProvider.myIp) continue;
      String connLink = 'http://${peer.ip}:${peer.port}$clientAddedEndPoint';
      var jsonRequest = json.encode(
        serverProvider.peers
            .map(
              (e) => e.toJSON(),
            )
            .toList(),
      );
      var encodedRequest = jsonRequest;
      await Dio().post(
        connLink,
        data: encodedRequest,
      );
    }
  } catch (e, s) {
    CustomException(
      e: e,
      s: s,
      rethrowError: true,
    );
  }
}
