import 'package:explorer/constants/models_constants.dart';

//? db name
const String tempDbName = 'tempDbName.db';

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
const String thumbnailPathTableName = 'thumbnailPath';
const String recentlyOpenedFilesTableName = 'recentlyOpenedFiles';
const String listyListTableName = 'listyList';
const String listyItemsTableName = 'listyItems';
const String shareSpaceItemsTableName = 'shareSpaceItems';

//? creating tables queries
const String imagesThumbnailsTableCreation =
    'CREATE TABLE $thumbnailPathTableName ($pathString TEXT PRIMARY KEY, $thumbnailStringPath TEXT)';
const String recentlyOpenedFilesTableCreation =
    'CREATE TABLE $recentlyOpenedFilesTableName ($pathString TEXT PRIMARY KEY, $dateFileOpenedString TEXT)';
const String listyListTableCreation =
    'CREATE TABLE $listyListTableName ($titleString TEXT PRIMARY KEY, $iconString TEXT, $createdAtString TEXT)';
const String listyItemsTableCreation =
    'CREATE TABLE $listyItemsTableName ($idString TEXT PRIMARY KEY, $pathString TEXT, $listyTitleString TEXT, $createdAtString TEXT, $entityTypeString TEXT)';
const String shareSpaceItemsTableCreation =
    'CREATE TABLE $shareSpaceItemsTableName ($pathString TEXT PRIMARY KEY, $entityTypeString TEXT, $blockedAtString TEXT, $ownerIDString TEXT, $addedAtString TEXT, $ownerSessionIDString TEXT, $sizeString TEXT)';
