import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

//? handling permissions
Future<bool> handleStoragePermissions(
    {required BuildContext context, required VoidCallback callback}) async {
  if (await Permission.storage.isDenied) {
    //! show a modal first
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