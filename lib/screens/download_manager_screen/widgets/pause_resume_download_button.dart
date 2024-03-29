// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PauseResumeControllers extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;
  const PauseResumeControllers({
    super.key,
    required this.downloadTaskModel,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      padding: EdgeInsets.all(smallPadding),
      borderRadius: smallBorderRadius,
      onTap: () {
        downPF(context).togglePauseResumeTask(
          downloadTaskModel.id,
          serverPF(context),
          sharePF(context),
        );
      },
      child: Image.asset(
        'assets/icons/${downloadTaskModel.taskStatus == TaskStatus.downloading ? 'pause' : 'play'}.png',
        width: smallIconSize,
        color: kMainIconColor.withOpacity(.6),
      ),
    );
  }
}
