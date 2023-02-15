// import 'package:explorer/global/modals/double_buttons_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StoragePermissions {
//   bool storagePermissionGranted = false;
//   bool manageStoragePermissionsGranted = false;
//   BuildContext context;

//   StoragePermissions(this.context);

//   Future<void> init() async {
//     await _checkGranted();
//     await _requestPermissions();
//     await _checkGranted();
//   }

//   Future<void> _checkGranted() async {
//     storagePermissionGranted = await Permission.storage.isGranted;
//     manageStoragePermissionsGranted =
//         await Permission.manageExternalStorage.isGranted;
//   }

//   Future<void> _requestPermissions() async {
//     await Permission.storage.request();
//     await Permission.manageExternalStorage.request();
//   }

//   Future<void> _showRequestDialog() async {
//     bool res = false;

//     await showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) => DoubleButtonsModal(
//         autoPop: false,
//         onOk: () async {
//           res = await _handleStoragePermissions(
//             context: context,
//             callback: callback,
//           );
//           Navigator.pop(ctx);
//         },
//         onCancel: () {
//           SystemNavigator.pop();
//         },
//         title: 'Allow Permissions',
//         subTitle: 'This app needs storage permissions to work',
//         okText: 'Allow',
//         cancelText: 'Exit',
//         okColor: kBlueColor,
//         cancelColor: kBackgroundColor,
//       ),
//     );
//   }
// }
