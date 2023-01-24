import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';

class ShareSpaceItemModel {
  final String path;
  final EntityType entityType;
  final List<String> blockedAt;
  final String ownerID;
  final DateTime addedAt;

  const ShareSpaceItemModel({
    required this.blockedAt,
    required this.entityType,
    required this.path,
    required this.ownerID,
    required this.addedAt,
  });

  Map<String, String> toJSON() {
    return {
      pathString: path,
      entityTypeString: entityType.name,
      blockedAtString: blockedAt.join('||'),
      ownerIDString: ownerID,
      addedAtString: addedAt.toIso8601String(),
    };
  }

  static ShareSpaceItemModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return ShareSpaceItemModel(
      blockedAt: (jsonOBJ[blockedAtString] as String).split('||'),
      entityType: stringToEnum(jsonOBJ[entityTypeString], EntityType.values),
      path: jsonOBJ[pathString] as String,
      ownerID: jsonOBJ[ownerIDString] as String,
      addedAt: DateTime.parse(jsonOBJ[addedAtString]),
    );
  }
}
