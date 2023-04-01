class VersionModel {
  final String version;
  final String link;

  const VersionModel({
    required this.version,
    required this.link,
  });

  static VersionModel fromJSON(Map<String, dynamic> jsonOBJ) {
    return VersionModel(
      version: jsonOBJ['version'],
      link: jsonOBJ['link'],
    );
  }

  @override
  String toString() {
    return 'version: $version\nlink:$link';
  }
}
