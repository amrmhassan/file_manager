// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FinishedTaskInfo extends StatelessWidget {
  final VoidCallback navigateToFile;
  const FinishedTaskInfo({
    super.key,
    required this.downloadTaskModel,
    required this.navigateToFile,
  });

  final DownloadTaskModel downloadTaskModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(factor: .3),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              handleConvertSize(downloadTaskModel.size!),
              style: h4TextStyleInactive,
            ),
            Spacer(),
            ButtonWrapper(
              padding: EdgeInsets.all(smallPadding),
              borderRadius: smallBorderRadius,
              onTap: navigateToFile,
              child: Image.asset(
                'assets/icons/folder_empty.png',
                width: smallIconSize,
                color: kMainIconColor.withOpacity(.6),
              ),
            ),
            HSpace(factor: .6),
            ButtonWrapper(
              padding: EdgeInsets.all(smallPadding),
              borderRadius: smallBorderRadius,
              onTap: () {
                confirmDeleteEntityModal(
                  context: context,
                  title: 'delete-this-task'.i18n(),
                  subTitle: 'delete-file-also'.i18n(),
                  cancelText: 'task-only'.i18n(),
                  okText: 'also-file'.i18n(),
                  onOk: () async {
                    // this will delete the task and the file associated with it
                    try {} catch (e) {
                      showSnackBar(
                        context: context,
                        message: 'file-doesnt-exist-already'.i18n(),
                        snackBarType: SnackBarType.error,
                      );
                    }
                    showSnackBar(
                      context: context,
                      message: 'deleted'.i18n(),
                    );
                    downPF(context).deleteTaskCompletely(
                      downloadTaskModel.id,
                      serverPF(context),
                      sharePF(context),
                      alsoFile: true,
                    );
                  },
                  onCancel: () async {
                    showSnackBar(
                      context: context,
                      message: 'deleted'.i18n(),
                    );
                    downPF(context).deleteTaskCompletely(
                      downloadTaskModel.id,
                      serverPF(context),
                      sharePF(context),
                      alsoFile: false,
                    );
                  },
                );
              },
              child: Image.asset(
                'assets/icons/delete.png',
                width: smallIconSize,
                color: kDangerColor.withOpacity(.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
