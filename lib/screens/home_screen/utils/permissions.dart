// ignore_for_file: use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

//? show require permissions modal
Future<bool> showPermissionsModal({
  required BuildContext context,
  required VoidCallback callback,
}) async {
  if ((await Permission.storage.isGranted) &&
      (await Permission.manageExternalStorage.isGranted)) {
    return handleStoragePermissions(context: context, callback: callback);
  }
  bool res = false;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DoubleButtonsModal(
      autoPop: false,
      onOk: () async {
        res = await handleStoragePermissions(
            context: context, callback: callback);
        Navigator.pop(ctx);
      },
      onCancel: () {
        SystemNavigator.pop();
      },
      title: 'Allow Permissions',
      subTitle: 'This app needs storage permissions to work',
      okText: 'Allow',
      cancelText: 'Exit',
      okColor: kBlueColor,
      cancelColor: kBackgroundColor,
    ),
  );
  return res;
}

//? handling permissions
Future<bool> handleStoragePermissions({
  required BuildContext context,
  required VoidCallback callback,
}) async {
  if (await Permission.storage.isDenied) {
    var readPermission = await Permission.storage.request();
    var managePermission = await Permission.manageExternalStorage.request();

    if (readPermission.isDenied ||
        readPermission.isPermanentlyDenied ||
        managePermission.isDenied ||
        managePermission.isPermanentlyDenied) {
      showSnackBar(
        context: context,
        message: 'Permission Not Granted',
        snackBarType: SnackBarType.error,
      );
      return false;
    } else {
      callback();
    }
  } else {
    callback();
  }
  return true;
}
