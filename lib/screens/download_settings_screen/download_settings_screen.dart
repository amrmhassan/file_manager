// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/max_parallel_downloads_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:localization/localization.dart';

class DownloadSetScreen extends StatelessWidget {
  static const String routeName = '/DownloadSettingsScreen';
  const DownloadSetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var downloadProvider = downP(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'download-settings'.i18n(),
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          ListTile(
            leading: Image.asset(
              'assets/icons/download-circular-button.png',
              width: mediumIconSize,
              color: kMainIconColor,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => MaximumParallelDownloadModal(
                  downloadProvider: downloadProvider,
                ),
              );
            },
            title: Text(
              'maximum-downloads'.i18n(),
              style: h4LightTextStyle,
            ),
            trailing: Text(
              downloadProvider.maxDownloadsAtAtime.toString(),
              style: h4TextStyleInactive,
            ),
          ),
          VSpace(),
          if (kDebugMode)
            ListTile(
              leading: Image.asset(
                'assets/icons/delete.png',
                width: mediumIconSize,
                color: kDangerColor,
              ),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    autoPop: true,
                    onOk: () {
                      downPF(context).clearAllTasks(
                        serverPF(context),
                        sharePF(context),
                      );
                      showSnackBar(
                        context: context,
                        message: 'deleted'.i18n(),
                      );
                    },
                    title: 'confirm-delete'.i18n(),
                    subTitle: 'delete-task-note'.i18n(),
                  ),
                );
              },
              title: Text(
                'delete-with-files-task'.i18n(),
                style: h4LightTextStyle,
              ),
            ),
        ],
      ),
    );
  }
}
