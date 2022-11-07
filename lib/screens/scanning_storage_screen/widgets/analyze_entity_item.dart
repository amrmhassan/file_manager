// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/explorer_screen/widgets/home_item_h_line.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';

class AnalyzeEntityItem extends StatefulWidget {
  final LocalFileInfo fileSystemEntity;
  final int parentSize;
  const AnalyzeEntityItem({
    super.key,
    required this.fileSystemEntity,
    required this.parentSize,
  });

  @override
  State<AnalyzeEntityItem> createState() => _AnalyzeEntityItemState();
}

class _AnalyzeEntityItemState extends State<AnalyzeEntityItem> {
  final GlobalKey key = GlobalKey();
  double? height;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        height = key.currentContext?.size?.height;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = widget.fileSystemEntity.size / widget.parentSize;
    return Stack(
      children: [
        Container(
          width: Responsive.getWidthPercentage(
            context,
            percentage,
          ),
          height: height,
          color: kInactiveColor.withOpacity(.2),
        ),
        ButtonWrapper(
          key: key,
          borderRadius: 0,
          onTap: () {},
          child: Column(
            children: [
              VSpace(factor: .5),
              PaddingWrapper(
                child: Row(
                  children: [
                    Image.asset(
                      getFileTypeIcon(
                          path.extension(widget.fileSystemEntity.path)),
                      width: largeIconSize,
                    ),
                    HSpace(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getFileNameAndExt(
                                widget.fileSystemEntity.fileBaseName)[0],
                            style: h4LightTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                handleConvertSize(widget.fileSystemEntity.size),
                                style: h4TextStyleInactive.copyWith(
                                  color: kInactiveColor,
                                  height: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    ' | ',
                                    style: h4TextStyleInactive.copyWith(
                                      color: kInactiveColor,
                                      height: 1,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        widget.fileSystemEntity.modified),
                                    style: h4TextStyleInactive.copyWith(
                                      color: kInactiveColor,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${(percentage * 100).toStringAsFixed(2)} %',
                      style: h4TextStyleInactive.copyWith(
                        color: kInActiveTextColor.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
              VSpace(factor: .5),
              HomeItemHLine(),
            ],
          ),
        ),
      ],
    );
  }

  List<String> getFileNameAndExt(String baseName) {
    String ext = baseName.split('.').last;
    List nameList = baseName.split('.');
    nameList.removeLast();
    String nameString = nameList.join();
    return [nameString, ext];
  }
}
