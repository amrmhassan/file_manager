import 'package:explorer/constants/models_constants.dart';

class WhiteBlockListModel {
  final String deviceID;
  final String name;

  const WhiteBlockListModel({
    required this.deviceID,
    required this.name,
  });

  Map<String, String> toJSON() {
    return {
      deviceIDString: deviceID,
      nameString: name,
    };
  }

  static WhiteBlockListModel fromJSON(Map<String, dynamic> obj) {
    return WhiteBlockListModel(
      deviceID: obj[deviceIDString],
      name: obj[nameString],
    );
  }
}
