import 'dart:async';

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_operations;

//? on create a database
FutureOr<void> onCreateDatabase(
  Database db,
  int? version,
) async {
  String dbBaseName = path_operations.basename(db.path);
  if (dbBaseName == tempDbName) {
    await onTempDataBase(db, version);
  } else if (dbBaseName == persistentDbName) {
    await onPersistentDataBase(db, version);
  }
}

//? on create the temp database
FutureOr<void> onTempDataBase(
  Database db,
  int? version,
) async {
  //? create recent images table
  await db.execute(
      'CREATE TABLE $imagesRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent downloads table
  await db.execute(
      'CREATE TABLE $downloadsRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent images table
  await db.execute(
      'CREATE TABLE $docsRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent images table
  await db.execute(
      'CREATE TABLE $archivesRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent apk table
  await db.execute(
      'CREATE TABLE $apkRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent music table
  await db.execute(
      'CREATE TABLE $musicRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create recent video table
  await db.execute(
      'CREATE TABLE $videosRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)');
  //? create extension info table
  await db.execute(ExtensionInfo.toSQLString());
  //? creating analyzer reports table
  await db.execute(AnalyzerReportInfoModel.toSQLString());
  //? creating info of the analyzer folders info
  await db.execute(LocalFolderInfo.toSQLString());
  //? creating info of the explorer folders
  await db.execute(FolderItemInfoModel.toSQLString());
}

//? on create the temp database
FutureOr<void> onPersistentDataBase(
  Database db,
  int? version,
) async {
  await db.execute(imagesThumbnailsTableCreation);
}
