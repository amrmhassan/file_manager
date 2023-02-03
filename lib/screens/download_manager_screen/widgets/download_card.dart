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
import 'package:intl/intl.dart';
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
  // @override
  // void initState() {
  //   try {
  //     WidgetsBinding.instance.addPostFrameCallback(
  //       (timeStamp) {
  //         _scrollController.animateTo(-_scrollController.offset,
  //             duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  //       },
  //     );
  //   } catch (e) {
  //     printOnDebug(e);
  //   }
  //   super.initState();
  // }

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
              Text(
                widget.downloadTaskModel.taskStatus == TaskStatus.finished
                    ? widget.downloadTaskModel.finishedAt == null
                        ? capitalizeWord(
                            widget.downloadTaskModel.taskStatus.name)
                        : DateFormat('hh:mm aa')
                            .format(widget.downloadTaskModel.finishedAt!)
                    : capitalizeWord(widget.downloadTaskModel.taskStatus.name),
                style: h4TextStyleInactive,
              ),
            ],
          ),
          if (widget.downloadTaskModel.taskStatus == TaskStatus.downloading)
            DownloadPercentBar(
              downloadTaskModel: widget.downloadTaskModel,
            ),
          if (widget.downloadTaskModel.taskStatus == TaskStatus.finished)
            Column(
              children: [
                VSpace(factor: .3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      handleConvertSize(widget.downloadTaskModel.size!),
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
                          subTitle:
                              'Do you want to delete the actual file also?',
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
