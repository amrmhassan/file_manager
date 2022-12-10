import 'package:explorer/constants/models_constants.dart';

class RecentOpenedFileModel {
  final String id;
  final String path;
  final DateTime dateOpened;

  const RecentOpenedFileModel({
    required this.id,
    required this.dateOpened,
    required this.path,
  });

  Map<String, String> toJSON() {
    return {
      idString: id,
      pathString: path,
      dateFileOpenedString: dateOpened.toIso8601String(),
    };
  }

  static RecentOpenedFileModel fromJSON(Map<String, String> jsonOBJ) {
    return RecentOpenedFileModel(
      id: jsonOBJ[idString]!,
      dateOpened: DateTime.parse(jsonOBJ[dateFileOpenedString]!),
      path: jsonOBJ[pathString]!,
    );
  }
}
