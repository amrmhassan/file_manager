// ignore_for_file: use_build_context_synchronously

import 'package:device_info_plus/device_info_plus.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/shared_pref_constants.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:localization/localization.dart';

//? to save if granted in the shared prefs
Future<void> _setGranted(bool g) async {
  await SharedPrefHelper.setBool(permissionsGrantedKey, g);
}

//? to get the granted
Future<bool> _getGrantedPermissionsSharedPrefs() async {
  bool g = await SharedPrefHelper.getBool(permissionsGrantedKey) ?? false;
  return g;
}

//? to check if to show the dialog or not
Future<bool> _isGranted() async {
  return (await Permission.storage.isGranted) &&
      (await Permission.manageExternalStorage.isGranted);
}

//? to check if to show the dialog
Future<bool> _doShowDialog() async {
  bool granted = await _isGranted();
  bool savedGranted = await _getGrantedPermissionsSharedPrefs();
  bool normalStoragePermissions = await Permission.storage.isGranted;

  if (savedGranted && granted) {
    return true;
  } else if (granted) {
    return true;
  } else if (normalStoragePermissions && savedGranted) {
    return true;
  }
  return false;
}

//? show require permissions modal
Future<bool> showPermissionsModal({
  required BuildContext context,
  required VoidCallback callback,
}) async {
  bool showDialog = await _doShowDialog();
  if (showDialog) {
    return _handleStoragePermissions(context: context, callback: callback);
  }
  bool res = false;
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DoubleButtonsModal(
      autoPop: false,
      onOk: () async {
        res = await _handleStoragePermissions(
          context: context,
          callback: callback,
        );
        Navigator.pop(ctx);
      },
      onCancel: () {
        SystemNavigator.pop();
      },
      title: 'allow-permissions'.i18n(),
      subTitle: 'allow-permissions-note'.i18n(),
      okText: 'allow'.i18n(),
      cancelText: 'exit'.i18n(),
      okColor: kBlueColor,
      cancelColor: kBackgroundColor,
    ),
  );
  return res;
}

//? handling permissions
Future<bool> _handleStoragePermissions({
  required BuildContext context,
  required VoidCallback callback,
}) async {
  if (await Permission.storage.isDenied) {
    var sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

    var readPermission = await Permission.storage.request();
    var managePermission = await Permission.manageExternalStorage.request();
    if (sdkInt == 33) {
      //! this is an exception for sdk 33 because it doesn't allow read permissions (i don't know why )
      readPermission = PermissionStatus.granted;
    }
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
  await _setGranted(true);
  return true;
}
