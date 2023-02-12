import 'package:explorer/constants/models_constants.dart';
import 'package:hive/hive.dart';

part 'recent_opened_file_model.g.dart';

@HiveType(typeId: 5)
class RecentOpenedFileModel {
  @HiveField(0)
  final String path;
  @HiveField(1)
  final DateTime dateOpened;

  const RecentOpenedFileModel({
    required this.dateOpened,
    required this.path,
  });

  Map<String, String> toJSON() {
    return {
      pathString: path,
      dateFileOpenedString: dateOpened.toIso8601String(),
    };
  }

  static RecentOpenedFileModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return RecentOpenedFileModel(
      dateOpened: DateTime.parse(jsonOBJ[dateFileOpenedString]!),
      path: jsonOBJ[pathString]!,
    );
  }
}
