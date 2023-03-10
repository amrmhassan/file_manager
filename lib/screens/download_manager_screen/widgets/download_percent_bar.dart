// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_volume_controllers.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class DownloadPercentBar extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;

  const DownloadPercentBar({
    super.key,
    required this.downloadTaskModel,
  });
  double get widthFactor {
    if (downloadTaskModel.count == 0) {
      return 1;
    }
    return (downloadTaskModel.count / (downloadTaskModel.size ?? 1)) <= 0
        ? 1
        : (downloadTaskModel.count / (downloadTaskModel.size ?? 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(factor: .5),
        Container(
          color: Colors.white.withOpacity(.4),
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: widthFactor,
            child: Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
              ),
            ),
          ),
        ),
        VSpace(factor: .2),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${handleConvertSize(downloadTaskModel.count, 1)}/${handleConvertSize(downloadTaskModel.size!)}',
              style: h5TextStyle,
            ),
            Spacer(),
            Text(
              '${(downloadTaskModel.count / downloadTaskModel.size! * 100).toStringAsFixed(0)}%',
              style: h5TextStyle,
            ),
          ],
        ),
        VSpace(factor: .5),
      ],
    );
  }
}
