import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/models/analyzer_report_info_model.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<sql.Database> database(String table) async {
    final databasePathDir = await sql.getDatabasesPath();

    String finalPath = path.join(databasePathDir, dbName);

    // if (kDebugMode) {
    //   await sql.deleteDatabase(finalPath);
    //   await SharedPrefHelper.removeAllSavedKeys();
    // }

    return sql.openDatabase(
      finalPath,
      //? this is when creating the database itself so create all your tables here
      onCreate: (db, version) async {
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
