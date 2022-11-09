import 'package:explorer/analyzing_code/storage_analyzer/extensions/file_size.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/models/types.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

//? to get the size
String handleConvertSize(int sizeInByte) {
  String unit = '';
  double covertedSize = 0;
  if (sizeInByte < 1024) {
    covertedSize = sizeInByte * 1;
    unit = 'Byte';
  } else if (sizeInByte < 1024 * 1024) {
    covertedSize = sizeInByte.toKB;
    unit = 'KB';
  } else if (sizeInByte < 1024 * 1024 * 1024) {
    covertedSize = sizeInByte.toMB;
    unit = 'MB';
  } else {
    covertedSize = sizeInByte.toGB;
    unit = 'GB';
  }
  return '${double.parse(covertedSize.toStringAsFixed(2))}$unit';
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
