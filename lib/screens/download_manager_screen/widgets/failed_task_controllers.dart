// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class FailedTaskControllers extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;
  const FailedTaskControllers({
    super.key,
    required this.downloadTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ButtonWrapper(
          padding: EdgeInsets.all(mediumPadding),
          onTap: () async {
            var downloadProviderF = downPF(context);
            var serverProviderF = serverPF(context);
            var shareProviderF = sharePF(context);

            try {
              var res = await downloadProviderF.continueFailedTasks(
                downloadTaskModel,
                serverProviderF,
                shareProviderF,
              );
              if (!res) {
                showSnackBar(
                  context: context,
                  message: 'cant-resume-this-failed-task'.i18n(),
                  snackBarType: SnackBarType.error,
                );
              }
            } catch (e) {
              showSnackBar(context: context, message: e.toString());
            }
          },
          child: Image.asset(
            'assets/icons/reload.png',
            width: mediumIconSize / 1.5,
            color: kMainIconColor,
          ),
        ),
        HSpace(factor: .5),
        Text(
          'failed'.i18n(),
          style: h4TextStyleInactive,
        ),
      ],
    );
  }
}
