import 'dart:io';
import 'dart:math';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/models/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path_operations;

void printOnDebug(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

//? for showing a quick snack bar
void showSnackBar({
  required BuildContext context,
  required String message,
  Color? backgroundColor,
  Color? textColor,
  SnackBarType? snackBarType,
  bool aboveBottomNavBar = false,
  EdgeInsets? margin,
  VoidCallback? onActionTapped,
  String? actionString,
}) {
  try {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: aboveBottomNavBar ? SnackBarBehavior.floating : null,
        content: Text(
          message,
        ),
        backgroundColor: backgroundColor ??
            ((snackBarType ?? SnackBarType.info) == SnackBarType.success
                ? kGreenColor
                : (snackBarType ?? SnackBarType.info) == SnackBarType.error
                    ? kDangerColor
                    : null),
        margin: margin,
        action: SnackBarAction(
          label: actionString ?? 'Done',
          textColor: textColor ??
              ((snackBarType ?? SnackBarType.info) == SnackBarType.error ||
                      (snackBarType ?? SnackBarType.info) ==
                          SnackBarType.success ||
                      (snackBarType ?? SnackBarType.info) == SnackBarType.info
                  ? Colors.white
                  : null),
          onPressed: onActionTapped ?? () {},
        ),
      ),
    );
  } catch (e) {
    //
  }
}

void fastSnackBar({
  required String msg,
  SnackBarType? snackBarType,
  GlobalKey<NavigatorState>? navKey,
}) {
  BuildContext? ctx = (navKey ?? navigatorKey).currentContext;
  if (ctx == null) return;
  showSnackBar(
    context: ctx,
    message: msg,
    snackBarType: snackBarType,
  );
}

//? to get the size
String handleConvertSize(int sizeInByte, [int fixedTo = 2]) {
  String unit = '';
  double convertedSize = 0;
  if (sizeInByte < 1024) {
    convertedSize = sizeInByte * 1;
    unit = ' Byte';
  } else if (sizeInByte < 1024 * 1024) {
    convertedSize = sizeInByte.toKB;
    unit = ' KB';
  } else if (sizeInByte < 1024 * 1024 * 1024) {
    convertedSize = sizeInByte.toMB;
    unit = ' MB';
  } else {
    convertedSize = sizeInByte.toGB;
    unit = ' GB';
  }
  return '${double.parse(convertedSize.toStringAsFixed(fixedTo))}$unit';
}

//? get code snippet execution time
int getExecutionTime(VoidCallback callback) {
  DateTime before = DateTime.now();
  callback();
  DateTime after = DateTime.now();
  return after.difference(before).inMilliseconds;
}

//? to handle double to string
String doubleToString(double d, [int roundTo = 2]) {
  List<String> s = d.toStringAsFixed(roundTo).split('');
  for (int i = 0; i < roundTo; i++) {
    if (s.last == '0') {
      s.removeLast();
    }
  }

  if (s.last == '.') {
    s.removeLast();
  }
  return s.join();
}

//? copy to clipboard
void copyToClipboard(BuildContext context, String path,
    [bool showSnack = true]) {
  Clipboard.setData(ClipboardData(text: path));
  if (showSnack) showSnackBar(context: context, message: 'Copied To Clipboard');
}

//? capitalize a single word
String capitalizeWord(String s) {
  String firstLetter = s[0];
  String remaining = s.substring(1);
  return firstLetter.toUpperCase() + remaining;
}

//? capitalize a sentence
String capitalizeSentence(String s) {
  List<String> words = s.split(' ');
  var caps = words.map((e) => capitalizeWord(e));
  String capSentence = caps.join(' ');
  return capSentence;
}

//? get folder size from sqlite
Future<LocalFolderInfo?> getFolderSizeFromDb(String path) async {
  var data = (await HiveBox.localFolderInfoTableName).values;
  // var data =
  //     await DBHelper.getDataWhere(localFolderInfoTableName, pathString, path);
  if (data.isNotEmpty) {
    LocalFolderInfo? localFolderInfo = data.first;
    return localFolderInfo;
  }
  return null;
}

Directory? getWhatsAppDir() {
  Directory dir1 = Directory('sdcard/WhatsApp/Media/');
  Directory dir2 =
      Directory('sdcard/Android/media/com.whatsapp/WhatsApp/Media/');

  if (dir1.existsSync()) {
    return dir1;
  } else if (dir2.existsSync()) {
    return dir2;
  } else {
    return null;
  }
}

//? to format the duration
String formatDuration(Duration d) {
  var seconds = d.inSeconds;
  final days = seconds ~/ Duration.secondsPerDay;
  seconds -= days * Duration.secondsPerDay;
  final hours = seconds ~/ Duration.secondsPerHour;
  seconds -= hours * Duration.secondsPerHour;
  final minutes = seconds ~/ Duration.secondsPerMinute;
  seconds -= minutes * Duration.secondsPerMinute;

  final List<String> tokens = [];
  if (days != 0) {
    tokens.add('$days');
  }
  if (tokens.isNotEmpty || hours != 0) {
    tokens.add('$hours');
  }
  if (tokens.isNotEmpty || minutes != 0) {
    tokens.add('$minutes');
  }
  tokens.add('${seconds < 10 ? '0$seconds' : seconds}');

  return tokens.join(':');
}

//? to create a new random path from a certain path
String createNewPath(String path) {
  String fileName = getFileName(path);
  String randomName =
      '${fileName}_${DateTime.now().toIso8601String()}${Random().nextInt(10000)}';
  String fileExt = getFileExtension(path);
  String parentName = path_operations.dirname(path);
  String newPath = '$parentName/$randomName.$fileExt';
  return newPath;
}
