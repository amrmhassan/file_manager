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
        backgroundColor:
            (snackBarType ?? SnackBarType.info) == SnackBarType.success
                ? kGreenColor
                : (snackBarType ?? SnackBarType.info) == SnackBarType.error
                    ? kDangerColor
                    : null,
        margin: margin,
        action: SnackBarAction(
          label: actionString ?? 'تم',
          textColor: (snackBarType ?? SnackBarType.info) ==
                      SnackBarType.error ||
                  (snackBarType ?? SnackBarType.info) == SnackBarType.success ||
                  (snackBarType ?? SnackBarType.info) == SnackBarType.info
              ? Colors.white
              : null,
          onPressed: onActionTapped ?? () {},
        ),
      ),
    );
  } catch (e) {
    //
  }
}
