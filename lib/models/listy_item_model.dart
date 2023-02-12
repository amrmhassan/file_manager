import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';
import 'package:hive/hive.dart';

part 'listy_item_model.g.dart';

@HiveType(typeId: 3)
class ListyItemModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String path;
  @HiveField(2)
  final String listyTitle;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final EntityType entityType;

  const ListyItemModel({
    required this.id,
    required this.path,
    required this.listyTitle,
    required this.createdAt,
    required this.entityType,
  });

  Map<String, String> toJSON() {
    return {
      idString: id,
      pathString: path,
      listyTitleString: listyTitle,
      createdAtString: createdAt.toIso8601String(),
      entityTypeString: entityType.name,
    };
  }

  static ListyItemModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return ListyItemModel(
      id: jsonOBJ[idString],
      path: jsonOBJ[pathString],
      listyTitle: jsonOBJ[listyTitleString],
      createdAt: DateTime.parse(jsonOBJ[createdAtString]),
      entityType: stringToEnum(jsonOBJ[entityTypeString], EntityType.values),
    );
  }
}
