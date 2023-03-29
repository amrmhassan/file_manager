import 'dart:typed_data';

class BeaconServerModel {
  // this id will be set locally by each discoverer, not from the beacon server
  final String id;
  final String deviceName;
  String? connQueryLink;
  Uint8List? serverImage;
  // this will be calculated from an endpoint and will depend on multiple calculations of response time in ms,
  // it won't define the actual distance but it will be used to compare with multiple beacon servers
  final double distanceFactor;

  BeaconServerModel({
    required this.id,
    required this.deviceName,
    this.serverImage,
    this.connQueryLink,
    this.distanceFactor = 0,
  });
}
