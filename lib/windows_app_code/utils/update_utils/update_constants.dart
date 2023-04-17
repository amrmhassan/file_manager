import 'package:explorer/models/version_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateConstants {
  static bool allowUpdates = true;
  // static const String currentVersion = '6.7.2';
  static const String collectionName = 'laptop';

  static Future<VersionModel> getCurrentVersion() async {
    var res = await PackageInfo.fromPlatform();
    return VersionModel.fromString(res.version);
  }
}
