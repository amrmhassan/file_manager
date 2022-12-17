import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/string_to_type.dart';
import 'package:explorer/models/types.dart';

class ListyItemModel {
  final String id;
  final String path;
  final String listyTitle;
  final DateTime createdAt;
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
