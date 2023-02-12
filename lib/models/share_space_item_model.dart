import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';
import 'package:hive/hive.dart';

part 'share_space_item_model.g.dart';

@HiveType(typeId: 6)
class ShareSpaceItemModel {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final EntityType entityType;
  @HiveField(2)
  final List<String> blockedAt;
  @HiveField(3)
  final String ownerDeviceID;
  @HiveField(4)
  String? ownerSessionID;
  @HiveField(5)
  final DateTime addedAt;
  @HiveField(6)
  int? size;

  ShareSpaceItemModel({
    required this.blockedAt,
    required this.entityType,
    required this.path,
    required this.ownerDeviceID,
    required this.ownerSessionID,
    required this.addedAt,
    this.size,
  });

  Map<String, dynamic> toJSON() {
    return {
      pathString: path
          .replaceAll('\\', '/')
          .replaceFirst(':', ':/')
          .replaceAll("//", '/'),
      entityTypeString: entityType.name,
      blockedAtString: blockedAt.join('||'),
      ownerIDString: ownerDeviceID,
      addedAtString: addedAt.toIso8601String(),
      ownerSessionIDString: ownerSessionID ?? dbNull,
      sizeString: size ?? dbNull,
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
      size: jsonOBJ[sizeString] == dbNull
          ? null
          : int.parse((jsonOBJ[sizeString]).toString()),
    );
  }
}
