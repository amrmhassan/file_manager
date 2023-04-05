// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/download_algorithm_modal.dart';
import 'package:explorer/global/modals/max_file_splits_modal.dart';
import 'package:explorer/global/modals/max_parallel_downloads_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/download_provider.dart';
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
          ListTile(
            leading: Image.asset(
              'assets/icons/algorithm.png',
              width: mediumIconSize,
              color: kMainIconColor,
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => DownloadingAlgorithmModal(
                  downloadProvider: downloadProvider,
                ),
              );
            },
            title: Text(
              'downloading-algorithm'.i18n(),
              style: h4LightTextStyle,
            ),
            trailing: Text(
              DownloadProvider.getDownloadAlgorithmName(
                downloadProvider.downloadAlgorithm,
              ),
              style: h4TextStyleInactive,
            ),
          ),
          VSpace(),
          PaddingWrapper(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    downloadProvider.downloadAlgorithm ==
                            DownloadAlgorithm.customDownload
                        ? 'downloading-algo-note1'.i18n()
                        : 'downloading-algo-note2'.i18n(),
                    style: h4TextStyleInactive,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
          if (downloadProvider.downloadAlgorithm ==
              DownloadAlgorithm.customDownload)
            ListTile(
              leading: Image.asset(
                'assets/icons/split.png',
                width: mediumIconSize,
                color: kMainIconColor,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => MaxFileSplitsModal(
                    downloadProvider: downloadProvider,
                  ),
                );
              },
              title: Text(
                'max-file-splits'.i18n(),
                style: h4LightTextStyle,
              ),
              trailing: Text(
                downloadProvider.maximumDownloadSplitsForAFile.toString(),
                style: h4TextStyleInactive,
              ),
            ),
          if (downloadProvider.downloadAlgorithm ==
              DownloadAlgorithm.customDownload)
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
