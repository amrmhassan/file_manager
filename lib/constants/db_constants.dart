//? db names
import 'package:explorer/constants/models_constants.dart';

const String dbName = 'dbName.db';

//? tables
// this will hold the folder info like it's itmes count
const String folderInfoTableName = 'folderInfo';
const String localFolderInfoTableName = 'localFolderInfo';
const String analyzerReportInfoTableName = 'analyzerReportInfo';
const String extensionInfoTableName = 'extensionInfo';
const String imagesRecentFilesTableName = 'imagesRecentFiles';
const String videosRecentFilesTableName = 'videosRecentFiles';
const String docsRecentFilesTableName = 'docsRecentFiles';
const String musicRecentFilesTableName = 'musicRecentFiles';
const String apkRecentFilesTableName = 'apkRecentFiles';
const String downloadsRecentFilesTableName = 'downloadsRecentFiles';
const String archivesRecentFilesTableName = 'archivesRecentFiles';

//? db limitations strings
const String dbNull = 'dbNull';
const String dbTrue = 'dbTrue';
const String dbFalse = 'dbFalse';

//? creating tables queries
const String imagesTableCreation =
    'CREATE TABLE $imagesRecentFilesTableName ($pathString TEXT PRIMARY KEY, $parentPathString TEXT, $modifiedString TEXT, $accessedString TEXT, $changedString TEXT, $entityTypeString TEXT, $fileBaseNameString TEXT, $extString TEXT, $sizeString TEXT)';
