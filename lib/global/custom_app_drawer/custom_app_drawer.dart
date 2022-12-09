// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/custom_app_drawer/widgets/app_drawer_item.dart';
import 'package:explorer/global/custom_app_drawer/widgets/light_theme_check_box.dart';
import 'package:explorer/global/custom_app_drawer/widgets/storage_analyzer_button.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/helpers/shared_pref_helper.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            LightThemeCheckBox(),
            StorageAnalyzerButton(),
            AppDrawerItem(
              title: 'Clear Temp DB & Keys',
              onTap: () async {
                await DBHelper.clearDb(tempDbName);
                await SharedPrefHelper.removeAllSavedKeys();
                showSnackBar(context: context, message: 'Deleted');
                Navigator.pop(context);
              },
              onlyDebug: true,
            ),
            AppDrawerItem(
              title: 'Clear Persist DB',
              onTap: () async {
                await DBHelper.clearDb(persistentDbName);
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
                  filesOperationsProvider: Provider.of<FilesOperationsProvider>(
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
      ),
    );
  }
}
