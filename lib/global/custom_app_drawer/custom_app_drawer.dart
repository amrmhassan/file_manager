// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/global/custom_app_drawer/widgets/storage_analyzer_button.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/hive/hive_collections.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';

import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/about_us_screen/about_us_screen.dart';
import 'package:explorer/screens/download_manager_screen/download_manager_screen.dart';
import 'package:explorer/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:explorer/screens/settings_screen/settings_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var downloadProvider = Provider.of<DownloadProvider>(context);
    var activeTasks = downloadProvider.activeTasks;
    return Container(
      color: kBackgroundColor,
      child: Container(
        color: kBackgroundColor,
        width: Responsive.getWidthPercentage(context, .75),
        height: double.infinity,
        child: Column(
          children: [
            VSpace(factor: 4),
            Image.asset(
              'assets/icons/logo.png',
              width: largeIconSize * 3,
            ),
            VSpace(factor: 2),
            // LightThemeCheckBox(),

            AppDrawerItem(
              iconPath: 'qr-code',
              title: 'QR Scanner',
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  ScanQRCodeScreen.routeName,
                  arguments: true,
                );
              },
              onlyDebug: true,
            ),
            AppDrawerItem(
              iconPath: 'download-circular-button',
              title: 'Downloads',
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  DownloadManagerScreen.routeName,
                );
              },
              onlyDebug: true,
              allowBadge: activeTasks.isNotEmpty,
              badgeContent: activeTasks.length.toString(),
            ),
            StorageAnalyzerButton(),
            AppDrawerItem(
              iconPath: 'settings',
              title: 'Settings',
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
              onlyDebug: true,
            ),

            AppDrawerItem(
              iconPath: 'info',
              title: 'About us',
              onTap: () async {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutUsScreen.routeName);
              },
              onlyDebug: true,
            ),
            if (allowDebuggingDrawerElements && kDebugMode)
              Column(
                children: [
                  AppDrawerItem(
                    title: 'Clear Temp DB & Keys',
                    onTap: () async {
                      Navigator.pop(context);
                      await tempCollection.deleteCollection();
                      await SharedPrefHelper.removeAllSavedKeys();
                      showSnackBar(context: context, message: 'Deleted');
                    },
                    onlyDebug: true,
                  ),
                  AppDrawerItem(
                    title: 'Clear Persist DB',
                    onTap: () async {
                      await persistentCollection.deleteCollection();
                      showSnackBar(context: context, message: 'Deleted');
                      Navigator.pop(context);
                    },
                    onlyDebug: true,
                  ),
                  AppDrawerItem(
                    title: 'Clear Devices db',
                    onTap: () async {
                      (await HiveBox.allowedDevices).deleteFromDisk();
                      (await HiveBox.blockedDevices).deleteFromDisk();
                      showSnackBar(context: context, message: 'Deleted');
                      Navigator.pop(context);
                    },
                    onlyDebug: true,
                  ),
                  AppDrawerItem(
                    title: 'App Data Explorer',
                    onTap: () async {
                      Directory tempDir = await getTemporaryDirectory();
                      tempDir = tempDir.parent;
                      //
                      var expProvider =
                          Provider.of<ExplorerProvider>(context, listen: false);
                      expProvider.setActiveDir(
                        path: tempDir.path,
                        filesOperationsProvider:
                            Provider.of<FilesOperationsProvider>(
                          context,
                          listen: false,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    onlyDebug: true,
                  ),
                ],
              ),
            // AppDrawerItem(
            //   title: 'Settings',
            //   onTap: () async {
            //     showSnackBar(context: context, message: 'Soon');
            //     Navigator.pop(context);
            //   },
            //   onlyDebug: true,
            // ),
          ],
        ),
      ),
    );
  }
}
