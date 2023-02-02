// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class DownloadCard extends StatelessWidget {
  const DownloadCard({
    super.key,
    required this.downloadTaskModel,
  });

  final DownloadTaskModel downloadTaskModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(
          mediumBorderRadius,
        ),
      ),
      margin: EdgeInsets.all(kVPad / 2),
      padding: EdgeInsets.symmetric(
        horizontal: kHPad,
        vertical: kVPad / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  path_operations.basename(downloadTaskModel.remoteFilePath),
                  style: h4TextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              Text(
                capitalizeWord(downloadTaskModel.taskStatus.name),
                style: h4TextStyleInactive,
              ),
            ],
          ),
          if (downloadTaskModel.taskStatus == TaskStatus.downloading)
            DownloadPercentBar(
              downloadTaskModel: downloadTaskModel,
            ),
        ],
      ),
    );
  }
}

class DownloadPercentBar extends StatelessWidget {
  final DownloadTaskModel downloadTaskModel;

  const DownloadPercentBar({
    super.key,
    required this.downloadTaskModel,
  });

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
            widthFactor: downloadTaskModel.count / downloadTaskModel.size!,
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
              '${handleConvertSize(downloadTaskModel.count, 0)}/${handleConvertSize(downloadTaskModel.size!)}',
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
