import 'package:hive/hive.dart';

part 'listy_model.g.dart';

@HiveType(typeId: 4)
class ListyModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String icon;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final String id;

  const ListyModel({
    required this.title,
    required this.icon,
    required this.createdAt,
    required this.id,
  });

  // Map<String, String?> toJSON() {
  //   return {
  //     titleString: title,
  //     iconString: icon,
  //     createdAtString: createdAt.toIso8601String(),
  //   };
  // }

  // static ListyModel fromJSON(Map<String, dynamic> jsonOBJ) {
  //   return ListyModel(
  //     title: jsonOBJ[titleString],
  //     icon: jsonOBJ[iconString] == dbNull ? null : jsonOBJ[iconString],
  //     createdAt: DateTime.parse(jsonOBJ[createdAtString]),
  //   );
  // }
}
