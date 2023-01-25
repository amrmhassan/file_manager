import 'package:explorer/providers/share_provider.dart';

class PeerModel {
  final String deviceID;
  final String name;
  final DateTime joinedAt;
  final MemberType memberType;

  const PeerModel({
    required this.deviceID,
    required this.joinedAt,
    required this.name,
    required this.memberType,
  });
}
