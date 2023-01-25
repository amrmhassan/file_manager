import 'package:explorer/providers/share_provider.dart';

class PeerModel {
  final String deviceID;
  final String name;
  final DateTime joinedAt;
  final MemberType memberType;
  final String ip;
  final int port;
  final String sessionID;

  const PeerModel({
    required this.deviceID,
    required this.joinedAt,
    required this.name,
    required this.memberType,
    required this.ip,
    required this.port,
    required this.sessionID,
  });
}
