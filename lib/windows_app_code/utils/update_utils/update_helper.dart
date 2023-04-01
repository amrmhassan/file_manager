import 'package:firedart/firestore/firestore.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/windows_app_code/utils/update_utils/update_constants.dart';
import 'package:explorer/windows_app_code/utils/update_utils/version_mode.dart';

class UpdateHelper {
  List<VersionModel>? versions;
  bool needUpdate = false;
  VersionModel? latestVersion;
  String? latestVersionLink;

  Future<void> init() async {
    try {
      var map = await Firestore.instance.collection("laptop").get();
      versions =
          map.map((element) => VersionModel.fromJSON(element.map)).toList();
      latestVersion = getLatestVersion();
      needUpdate = setNeedUpdate();
      latestVersionLink = getLatestVersionLink();
    } catch (e) {
      logger.e('cant load update data');
    }
  }

  VersionModel? getLatestVersion() {
    if (versions == null) return null;
    return versions?.last;
  }

  bool setNeedUpdate() {
    if (latestVersion == null) return false;
    return latestVersion!.version != UpdateConstants.currentVersion;
  }

  String? getLatestVersionLink() {
    if (latestVersion == null) return null;
    return latestVersion!.link;
  }
}
