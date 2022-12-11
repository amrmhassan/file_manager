import 'package:explorer/constants/models_constants.dart';

class RecentOpenedFileModel {
  final String path;
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
