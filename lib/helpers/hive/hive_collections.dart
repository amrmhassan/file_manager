import 'package:explorer/helpers/hive/hive_collection_model.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';

CustomHiveCollection tempCollection = CustomHiveCollection(boxes: [
  HiveBox.imagesRecentFilesTableName,
  HiveBox.downloadsRecentFilesTableName,
  HiveBox.docsRecentFilesTableName,
  HiveBox.archivesRecentFilesTableName,
  HiveBox.apkRecentFilesTableName,
  HiveBox.musicRecentFilesTableName,
  HiveBox.videosRecentFilesTableName,
  HiveBox.extensionInfoTableName,
  HiveBox.analyzerReportInfo,
]);

CustomHiveCollection persistentCollection = CustomHiveCollection(boxes: [
  HiveBox.thumbnailPathTableName,
  HiveBox.recentOpenedFile,
  HiveBox.listy,
  HiveBox.listyItem,
  HiveBox.shareSpaceItem,
  HiveBox.hiddenFromShareSpace,
  HiveBox.peerPermissionsBox,
  HiveBox.entityClickedBox,
]);
