// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/models/download_task_model.dart';
import 'package:explorer/screens/download_manager_screen/widgets/download_percent_bar.dart';
import 'package:explorer/screens/download_manager_screen/widgets/failed_task_controllers.dart';
import 'package:explorer/screens/download_manager_screen/widgets/finished_task_info.dart';
import 'package:explorer/screens/download_manager_screen/widgets/pause_resume_download_button.dart';
import 'package:explorer/screens/download_manager_screen/widgets/task_sub_info.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path_operations;

class DownloadCard extends StatefulWidget {
  const DownloadCard({
    super.key,
    required this.downloadTaskModel,
  });

  final DownloadTaskModel downloadTaskModel;

  @override
  State<DownloadCard> createState() => _DownloadCardState();
}

class _DownloadCardState extends State<DownloadCard> {
  final ScrollController _downloadCardScrollController = ScrollController();

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
                child: SingleChildScrollView(
                  controller: _downloadCardScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    path_operations
                        .basename(widget.downloadTaskModel.remoteFilePath),
                    style: h4TextStyle,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ),
              ),
              HSpace(factor: .7),
              widget.downloadTaskModel.taskStatus == TaskStatus.downloading ||
                      widget.downloadTaskModel.taskStatus == TaskStatus.paused
                  ? PauseResumeControllers(
                      downloadTaskModel: widget.downloadTaskModel,
                    )
                  : widget.downloadTaskModel.taskStatus == TaskStatus.failed
                      ? FailedTaskControllers(
                          downloadTaskModel: widget.downloadTaskModel,
                        )
                      : TaskSubInfo(
                          downloadTaskModel: widget.downloadTaskModel,
                        ),
            ],
          ),
          if (widget.downloadTaskModel.taskStatus == TaskStatus.downloading ||
              widget.downloadTaskModel.taskStatus == TaskStatus.paused)
            DownloadPercentBar(
              downloadTaskModel: widget.downloadTaskModel,
            )
          else if (widget.downloadTaskModel.taskStatus == TaskStatus.finished)
            FinishedTaskInfo(downloadTaskModel: widget.downloadTaskModel)
        ],
      ),
    );
  }
}
