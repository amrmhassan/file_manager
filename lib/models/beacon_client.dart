import 'package:explorer/models/peer_permissions_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'beacon_client.g.dart';

@HiveType(typeId: 17)
class BeaconClient {
  @HiveField(0)
  final String userID;
  @HiveField(1)
  final String userName;
  @HiveField(2)
  final PermissionStatus permissionStatus;

  const BeaconClient({
    required this.userID,
    required this.userName,
    required this.permissionStatus,
  });
}
