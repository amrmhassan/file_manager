import 'dart:io';
import 'dart:math';

import 'package:explorer/models/types.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

String laptopName = 'Laptop';
String laptopID = 'laptop_id';

late List<Directory> initialDirs;
final Logger logger = Logger();
// final CustomLoggerModel logger = CustomLoggerModel();

const Duration homePageViewDuration = Duration(milliseconds: 180);

//? animations durations
const Duration entitySizePercentageDuration = Duration(milliseconds: 200);
const Duration bottomActionsDuration = Duration(milliseconds: 230);
const Duration recentExpandDuration = Duration(milliseconds: 150);
const Duration segmentsDuration = Duration(milliseconds: 400);
const Duration thumbnailFadeDuration = Duration(milliseconds: 100);

//? animations constants
const bool allowSizesExpAnimation = true;
const bool allowDevBoxes = true;

//? sort options default
const SortOption defaultSortOption = SortOption.nameAsc;
const bool defaultShowHiddenFiles = false;
const bool defaultPriotorizeFolders = true;

//? theme constants
bool lightTheme = true;

//? debugging constants
const bool showAnalyzerStuff = false;
const bool allowVideoThumbnail = true;
const bool allowDebuggingDrawerElements = true;

//? user prefs constants
const bool allowRecentItemsFromHiddenFiles = true;

//? downloading folders
const String mainDownloadFolder = 'AFM Downloads';

const String apkDownloadFolder = 'Apps';
const String archiveDownloadFolder = 'Archive';
const String audioDownloadFolder = 'Audio';
const String docDownloadFolder = 'Documents';
const String imageDownloadFolder = 'Images';
const String videoDownloadFolder = 'Video';
const String otherDownloadFolder = 'Other';
const String foldersDownloadFolder = 'Folders';

//? storage item
const double height = 60;
GlobalKey storageItemKey = GlobalKey();

//? device props constants
String myDefaultName = 'No Name ${Random().nextInt(99)}';

//? downloads settings
int maxParallelDownloadTasksDefault = 1;

//? links
const String laptopClientDownloadLink = 'https://amh-file-manager.web.app';

//? localization
Locale arabicLocal = const Locale('ar', 'EG');
Locale englishLocal = const Locale('en', 'US');
List<Locale> supportedLocales = [arabicLocal, englishLocal];
