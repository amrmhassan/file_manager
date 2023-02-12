import 'package:explorer/constants/models_constants.dart';
import 'package:hive/hive.dart';

part 'white_block_list_model.g.dart';

@HiveType(typeId: 7)
class WhiteBlockListModel {
  @HiveField(0)
  final String deviceID;
  @HiveField(1)
  final String name;

  const WhiteBlockListModel({
    required this.deviceID,
    required this.name,
  });

  // Map<String, String> toJSON() {
  //   return {
  //     deviceIDString: deviceID,
  //     nameString: name,
  //   };
  // }

  // static WhiteBlockListModel fromJSON(Map<String, dynamic> obj) {
  //   return WhiteBlockListModel(
  //     deviceID: obj[deviceIDString],
  //     name: obj[nameString],
  //   );
  // }
}
