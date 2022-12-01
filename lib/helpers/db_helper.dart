// ignore_for_file: unused_import

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<String> getDbPath() async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, dbName);
    return finalPath;
  }

  static Future<sql.Database> database(String table) async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, dbName);

    return sql.openDatabase(
      finalPath,
      //? this is when creating the database itself so create all your tables here
      onCreate: (db, version) async {
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
        return db.execute(FolderItemInfoModel.toSQLString());
      },
      version: 1,
    );
  }

  static Future<void> clearDb() async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, dbName);

    await sql.deleteDatabase(finalPath);
  }

  static Future<void> insert(
    String table,
    Map<String, dynamic> data,
  ) async {
    final db = await DBHelper.database(table);

    await db.insert(
      table,
      data,
      //? this line is for replacing the data if the id already exists
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database(table);
    return await db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getDataWhere(
      String table, String key, String value) async {
    final db = await DBHelper.database(table);
    return db.query(table, where: '$key = ?', whereArgs: [value]);
  }

  static Future<void> deleteDatabase(String dbName) async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, dbName);
    return sql.deleteDatabase(finalPath);
  }

  static Future<void> deleteById(String id, String table) async {
    final db = await DBHelper.database(table);
    return db.execute("DELETE FROM $table WHERE $pathString='$id'");
  }

  static Future<void> deleteTable(String table) async {
    final db = await DBHelper.database(table);
    return db.execute('DELETE FROM $table');
  }
}
