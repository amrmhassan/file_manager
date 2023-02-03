// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class FinishedTaskInfo extends StatelessWidget {
  const FinishedTaskInfo({
    super.key,
    required this.downloadTaskModel,
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
              onTap: () {
                showSnackBar(context: context, message: 'Soon');
              },
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
                  title: 'Delete this task?',
                  subTitle: 'Do you want to delete the actual file also?',
                  cancelText: 'Task Only',
                  okText: 'Also File',
                  onOk: () {
                    showSnackBar(context: context, message: 'Soon');
                  },
                  onCancel: () {
                    showSnackBar(context: context, message: 'Soon');
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
