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
