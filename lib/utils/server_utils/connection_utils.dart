import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String getConnLink(
  String ip,
  int port, [
  String? endPoint,
  bool webSockets = false,
]) {
  return '${webSockets ? 'ws' : 'http'}://$ip:$port${endPoint ?? ''}';
}

String? getPeerConnLink(PeerModel? peerModel, String endPoint) {
  if (peerModel == null) return null;
  return '${getConnLink(peerModel.ip, peerModel.port)}$endPoint';
}

PeerModel me(BuildContext context) {
  var shareProvider = Provider.of<ShareProvider>(context, listen: false);
  var me =
      Provider.of<ServerProvider>(context, listen: false).me(shareProvider);
  return me;
}
