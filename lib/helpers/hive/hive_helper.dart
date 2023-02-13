import 'package:hive_flutter/hive_flutter.dart';

class HiveBox {
  static Future<Box> customBox(String name) async {
    return Hive.openBox(name);
  }

  static Future<Box> get allowedDevices =>
      Hive.openBox(_HiveBoxesNames.allowedDevices);
  static Future<Box> get blockedDevices =>
      Hive.openBox(_HiveBoxesNames.blockedDevices);
  static Future<Box> get downloadTasks =>
      Hive.openBox(_HiveBoxesNames.downloadTasks);
  static Future<Box> get hiddenFromShareSpace =>
      Hive.openBox(_HiveBoxesNames.hiddenFromShareSpace);
  static Future<Box> get analyzerReportInfo =>
      Hive.openBox(_HiveBoxesNames.analyzerReportInfo);
  static Future<Box> get folderInfo => Hive.openBox(_HiveBoxesNames.folderInfo);
  static Future<Box> get listyItem => Hive.openBox(_HiveBoxesNames.listyItem);
  static Future<Box> get listy => Hive.openBox(_HiveBoxesNames.listy);
  static Future<Box> get recentOpenedFile =>
      Hive.openBox(_HiveBoxesNames.recentOpenedFile);
  static Future<Box> get shareSpaceItem =>
      Hive.openBox(_HiveBoxesNames.shareSpaceItem);
  // recent boxes
  static Future<Box> get imagesRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.imagesRecentFilesTableName);
  static Future<Box> get videosRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.videosRecentFilesTableName);
  static Future<Box> get musicRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.musicRecentFilesTableName);
  static Future<Box> get apkRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.apkRecentFilesTableName);
  static Future<Box> get archivesRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.archivesRecentFilesTableName);
  static Future<Box> get docsRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.docsRecentFilesTableName);
  static Future<Box> get downloadsRecentFilesTableName =>
      Hive.openBox(_HiveBoxesNames.downloadsRecentFilesTableName);
  // local folder info
  static Future<Box> get localFolderInfoTableName =>
      Hive.openBox(_HiveBoxesNames.localFolderInfoTableName);

  static Future<Box> get thumbnailPathTableName =>
      Hive.openBox(_HiveBoxesNames.thumbnailPathTableName);

  static Future<Box> get extensionInfoTableName =>
      Hive.openBox(_HiveBoxesNames.extensionInfoTableName);
}

class _HiveBoxesNames {
  static const String downloadTasks = 'downloadTasksBoxName';
  static const String allowedDevices = 'allowedDevicesBoxName';
  static const String blockedDevices = 'blockedDevicesBoxName';
  static const String hiddenFromShareSpace = 'hiddenFromShareSpaceBoxName';
  static const String analyzerReportInfo = 'analyzerReportInfoBoxName';
  static const String folderInfo = 'folderInfoBoxName';
  static const String listyItem = 'listyItemBoxName';
  static const String listy = 'listyBoxName';
  static const String recentOpenedFile = 'recentOpenedFileBoxName';
  static const String shareSpaceItem = 'shareSpaceItemBoxName';
  // recent boxes
  static const String imagesRecentFilesTableName = 'imagesRecentFilesTableName';
  static const String videosRecentFilesTableName = 'videosRecentFilesTableName';
  static const String musicRecentFilesTableName = 'musicRecentFilesTableName';
  static const String apkRecentFilesTableName = 'apkRecentFilesTableName';
  static const String archivesRecentFilesTableName =
      'archivesRecentFilesTableName';
  static const String docsRecentFilesTableName = 'docsRecentFilesTableName';
  static const String downloadsRecentFilesTableName =
      'downloadsRecentFilesTableName';

  // local folder info
  static const String localFolderInfoTableName = 'localFolderInfoTableName';

  static const String thumbnailPathTableName = 'thumbnailPathTableName';
  static const String extensionInfoTableName = 'extensionInfoTableName';
}

// class HiveHelper {
//   final Box box;

//   const HiveHelper(this.box);

//   Iterable<dynamic> getDataLimit(int limit) {
//     List<dynamic> data = box.values.toList();
//     data.sort();
//     return data.take(limit);
//   }
// }
