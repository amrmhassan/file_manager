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
  final MemberType memberType;
  final String ip;
  final int port;
  final String sessionID;
  late String connLink;
  final DeviceType deviceType;
  late DateTime joinedAt;

  PeerModel({
    required this.deviceID,
    required this.name,
    required this.memberType,
    required this.ip,
    required this.port,
    required this.sessionID,
    required this.deviceType,
  }) {
    connLink = getConnLink(ip, port);
    joinedAt = DateTime.now();
  }

  String getMyLink(String endPoint) {
    return getPeerConnLink(this, endPoint)!;
  }

  Map<String, String> toJSON() {
    return {
      deviceIDString: deviceID,
      nameString: name,
      // joinedAtString: joinedAt.toIso8601String(),
      memberTypeString: memberType.name,
      ipString: ip,
      portString: port.toString(),
      sessionIDString: sessionID,
      deviceTypeString: deviceType.name,
    };
  }

  static PeerModel fromJSON(Map<String, dynamic> obj) {
    return PeerModel(
      deviceID: obj[deviceIDString],
      // joinedAt: DateTime.parse(obj[joinedAtString]),
      name: obj[nameString],
      memberType: stringToEnum(obj[memberTypeString], MemberType.values),
      ip: obj[ipString],
      port: int.parse(obj[portString]),
      sessionID: obj[sessionIDString],
      deviceType: stringToEnum(
        obj[deviceTypeString] ?? DeviceType.android.name,
        DeviceType.values,
      ),
    );
  }
}
