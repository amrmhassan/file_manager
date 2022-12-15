import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';

class ListyModel {
  final String title;
  final String? icon;
  final DateTime createdAt;

  const ListyModel({
    required this.title,
    this.icon,
    required this.createdAt,
  });

  Map<String, String?> toJSON() {
    return {
      titleString: title,
      iconString: icon ?? dbNull,
      createdAtString: createdAt.toIso8601String(),
    };
  }

  static ListyModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return ListyModel(
      title: jsonOBJ[titleString],
      icon: jsonOBJ[iconString] == dbNull ? null : jsonOBJ[iconString],
      createdAt: DateTime.parse(jsonOBJ[createdAtString]),
    );
  }
}
