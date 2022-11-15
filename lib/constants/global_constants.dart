import 'dart:io';

bool prioritizeFolders = true;
bool showHiddenFiles = true;
bool sortAlphapitacally = true;

const Duration homePageViewDuration = Duration(milliseconds: 180);

final Directory initialDir = Directory('sdcard');
//? animations durations
const Duration entitySizePercentageDuration = Duration(milliseconds: 200);
const Duration bottomActionsDuration = Duration(milliseconds: 230);
const Duration recentExpandDuration = Duration(milliseconds: 150);
//? animations constants
const bool allowNormalExpAnimation = true;
const bool allowSizesExpAnimation = true;
