import 'package:explorer/constants/models_constants.dart';

//? db name
const String dbName = 'dbName.db';

//? tables
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

//# persistent data base
//? db name
const String persistentDbName = 'persistentDbName.db';

//? tables
const String imgThumbnailPathTableName = 'imgThumbnailPath';

//? creating tables queries
const String imagesThumbnailsTableCreation =
    'CREATE TABLE $imgThumbnailPathTableName ($pathString TEXT PRIMARY KEY, $thumbnailStringPath TEXT)';
