import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';

//! add to from json here
//! make a new file for server constants
//! like headers and end points
class PeerModel {
  final String deviceID;
  final String name;
  final DateTime joinedAt;
  final MemberType memberType;
  final String ip;
  final int port;
  final String sessionID;
  late String connLink;

  PeerModel({
    required this.deviceID,
    required this.joinedAt,
    required this.name,
    required this.memberType,
    required this.ip,
    required this.port,
    required this.sessionID,
  }) {
    connLink = getConnLink(ip, port);
  }

  Map<String, String> toJSON() {
    return {
      deviceIDString: deviceID,
      nameString: name,
      joinedAtString: joinedAt.toIso8601String(),
      memberTypeString: memberType.name,
      ipString: ip,
      portString: port.toString(),
      sessionIDString: sessionID,
    };
  }

  static PeerModel fromJSON(Map<String, dynamic> obj) {
    return PeerModel(
      deviceID: obj[deviceIDString],
      joinedAt: DateTime.parse(obj[joinedAtString]),
      name: obj[nameString],
      memberType: stringToEnum(obj[memberTypeString], MemberType.values),
      ip: obj[ipString],
      port: int.parse(obj[portString]),
      sessionID: obj[sessionIDString],
    );
  }
}
