// ignore_for_file: unused_import

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/utils/db_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  //? to get the database path
  static Future<String> getDbPath(String databaseName) async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, databaseName);
    return finalPath;
  }

  //? to return the database
  static Future<sql.Database> database(
    String table, [
    String? databaseName,
  ]) async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, databaseName ?? tempDbName);

    return sql.openDatabase(
      finalPath,
      //? this is when creating the database itself so create all your tables here
      onCreate: onCreateDatabase,
      version: 1,
    );
  }

  //? to clear a database
  static Future<void> clearDb(
    String databaseName,
  ) async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, databaseName);

    await sql.deleteDatabase(finalPath);
  }

  //? to insert to a db
  static Future<void> insert(
    String table,
    Map<String, dynamic> data, [
    String? databaseName,
  ]) async {
    final db = await DBHelper.database(table, databaseName);

    await db.insert(
      table,
      data,
      //? this line is for replacing the data if the id already exists
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  //? to get all data from a table
  static Future<List<Map<String, dynamic>>> getData(
    String table, [
    String? databaseName,
  ]) async {
    final db = await DBHelper.database(table, databaseName);
    return await db.query(table);
  }

  //? to get all data with limit from a table
  static Future<List<Map<String, dynamic>>> getDataLimit({
    required String table,
    int? limit,
    String? orderProp,
    bool orderASC = true,
    String? databaseName,
  }) async {
    final db = await DBHelper.database(table, databaseName);
    String orderQuery = orderProp == null
        ? ''
        : 'ORDER BY $orderProp ${orderASC ? "ASC" : "DESC"}';
    String limitQuery = limit == null ? '' : 'LIMIT $limit';
    return db.rawQuery("""
                    SELECT * 
                    FROM $table
                    $orderQuery
                    $limitQuery
                    """);
  }

  //? to get data from a table where
  static Future<List<Map<String, dynamic>>> getDataWhere(
    String table,
    String key,
    String value, [
    String? databaseName,
  ]) async {
    final db = await DBHelper.database(table, databaseName);
    return db.query(table, where: '$key = ?', whereArgs: [value]);
  }

  //? to get data from a table where multiple keys apply
  static Future<List<Map<String, dynamic>>> getDataWhereMultiple(
    String table,
    List<String> keys,
    List<String> values, [
    String? databaseName,
  ]) async {
    if (keys.length != values.length) {
      throw Exception('key length must be the same as value length');
    }
    final db = await DBHelper.database(table, databaseName);
    String whereQuery = '';
    for (int i = 0; i < keys.length; i++) {
      whereQuery += "${keys[i]}='${values[i]}'";
      if (i < (keys.length - 1)) {
        whereQuery += ' AND ';
      }
    }

    String query = """
                    SELECT *
                    FROM $table
                    WHERE $whereQuery;
                    """;
    return db.rawQuery(query);
  }

  //? to delete data from a table where multiple keys apply
  static Future<List<Map<String, dynamic>>> deleteDataWhereMultiple(
    String table,
    List<String> keys,
    List<String> values, [
    String? databaseName,
  ]) async {
    if (keys.length != values.length) {
      throw Exception('key length must be the same as value length');
    }
    final db = await DBHelper.database(table, databaseName);
    String whereQuery = '';
    for (int i = 0; i < keys.length; i++) {
      whereQuery += "${keys[i]}='${values[i]}'";
      if (i < (keys.length - 1)) {
        whereQuery += ' AND ';
      }
    }

    String query = """
                    DELETE
                    FROM $table
                    WHERE $whereQuery;
                    """;
    return db.rawQuery(query);
  }

  //? to delete a database
  static Future<void> deleteDatabase(String databaseName) async {
    final databasePathDir = await sql.getDatabasesPath();
    String finalPath = path.join(databasePathDir, databaseName);
    return sql.deleteDatabase(finalPath);
  }

  //? to delete a record by id
  static Future<void> deleteById(
    String id,
    String table, [
    String? databaseName,
  ]) async {
    final db = await DBHelper.database(table, databaseName);
    return db.execute("DELETE FROM $table WHERE $pathString='$id'");
  }

  //? to delete a table
  static Future<void> deleteTable(
    String table, [
    String? databaseName,
  ]) async {
    final db = await DBHelper.database(table, databaseName);
    return db.execute('DELETE FROM $table');
  }
}
