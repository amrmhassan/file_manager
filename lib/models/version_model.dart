class VersionModel {
  final int major;
  final int minor;
  final int patch;

  const VersionModel(this.major, this.minor, this.patch);

  static VersionModel fromString(String v) {
    List<int> vNumbers = v.split('.').map((e) => int.parse(e)).toList();

    return VersionModel(vNumbers[0], vNumbers[1], vNumbers[2]);
  }

  bool isNewerThan(VersionModel versionModel) {
    if (major > versionModel.major) {
      return true;
    } else if (minor > versionModel.minor) {
      return true;
    } else if (patch > versionModel.patch) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return '$major.$minor.$patch';
  }
}
