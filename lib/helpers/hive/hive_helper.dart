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
}

class _HiveBoxesNames {
  static const String downloadTasks = 'downloadTasksBoxName';
  static const String allowedDevices = 'allowedDevicesBoxName';
  static const String blockedDevices = 'blockedDevicesBoxName';
  static const String hiddenFromShareSpace = 'hiddenFromShareSpaceBoxName';
}
