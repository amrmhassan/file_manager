import 'package:explorer/models/version_model.dart';

class VersionDataModel {
  final VersionModel version;
  final String link;

  const VersionDataModel({
    required this.version,
    required this.link,
  });

  static VersionDataModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return VersionDataModel(
      version: VersionModel.fromString(jsonOBJ['version']),
      link: jsonOBJ['link'],
    );
  }

  @override
  String toString() {
    return 'version: $version\nlink:$link';
  }
}
