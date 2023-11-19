// import 'package:explorer/models/version_model.dart';
// import 'package:firedart/firestore/firestore.dart';
// import 'package:explorer/constants/global_constants.dart';
// import 'package:explorer/windows_app_code/utils/update_utils/update_constants.dart';
// import 'package:explorer/windows_app_code/utils/update_utils/version_data_model.dart';

// class UpdateHelper {
//   List<VersionDataModel>? versions;
//   bool needUpdate = false;
//   VersionDataModel? latestVersionData;
//   String? latestVersionLink;

//   Future<void> init() async {
//     try {
//       var map = await Firestore.instance.collection("laptop").get();
//       versions =
//           map.map((element) => VersionDataModel.fromJSON(element.map)).toList();
//       latestVersionData = getLatestVersion();
//       needUpdate = await setNeedUpdate();
//       latestVersionLink = getLatestVersionLink();
//     } catch (e) {
//       logger.e('cant load update data');
//     }
//   }

//   VersionDataModel? getLatestVersion() {
//     if (versions == null) return null;
//     return versions?.last;
//   }

//   Future<bool> setNeedUpdate() async {
//     var currentVersion = await UpdateConstants.getCurrentVersion();
//     // var currentVersion = VersionModel.fromString('6.6.2');
//     if (latestVersionData == null) return false;
//     VersionModel latestVersion = latestVersionData!.version;
//     bool need = latestVersion.isNewerThan(currentVersion);
//     return need;
//   }

//   String? getLatestVersionLink() {
//     if (latestVersionData == null) return null;
//     return latestVersionData!.link;
//   }
// }
