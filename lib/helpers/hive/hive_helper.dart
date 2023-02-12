import 'package:hive_flutter/hive_flutter.dart';

class HiveBox {
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
}
