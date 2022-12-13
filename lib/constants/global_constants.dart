import 'dart:io';

import 'package:explorer/providers/explorer_provider.dart';

final Directory initialDir = Directory('sdcard');

const Duration homePageViewDuration = Duration(milliseconds: 180);

//? animations durations
const Duration entitySizePercentageDuration = Duration(milliseconds: 200);
const Duration bottomActionsDuration = Duration(milliseconds: 230);
const Duration recentExpandDuration = Duration(milliseconds: 150);
const Duration segmentsDuration = Duration(milliseconds: 400);

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
const bool allowVideoThumbnail = false;

//? user prefs constants
const bool allowRecentItemsFromHiddenFiles = true;
