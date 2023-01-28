import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';

class ShareSpaceItemModel {
  final String path;
  final EntityType entityType;
  final List<String> blockedAt;
  final String ownerDeviceID;
  String? ownerSessionID;
  final DateTime addedAt;
  int? size;

  ShareSpaceItemModel({
    required this.blockedAt,
    required this.entityType,
    required this.path,
    required this.ownerDeviceID,
    required this.ownerSessionID,
    required this.addedAt,
    this.size = 10000,
  });

  Map<String, String> toJSON() {
    return {
      pathString: path,
      entityTypeString: entityType.name,
      blockedAtString: blockedAt.join('||'),
      ownerIDString: ownerDeviceID,
      addedAtString: addedAt.toIso8601String(),
      ownerSessionIDString: ownerSessionID ?? dbNull,
    };
  }

  static ShareSpaceItemModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return ShareSpaceItemModel(
      blockedAt: (jsonOBJ[blockedAtString] as String).split('||'),
      entityType: stringToEnum(jsonOBJ[entityTypeString], EntityType.values),
      path: jsonOBJ[pathString] as String,
      ownerDeviceID: jsonOBJ[ownerIDString] as String,
      addedAt: DateTime.parse(jsonOBJ[addedAtString]),
      ownerSessionID: jsonOBJ[ownerSessionIDString] == dbNull
          ? null
          : jsonOBJ[ownerSessionIDString],
    );
  }
}
