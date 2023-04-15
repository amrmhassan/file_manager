// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/log_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class LogCard extends StatefulWidget {
  final LogModel logModel;
  const LogCard({
    super.key,
    required this.logModel,
  });

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  bool expanded = false;

  void toggleExpand() {
    setState(() {
      expanded = !expanded;
    });
  }

  Color levelColor() {
    if (widget.logModel.level.toLowerCase() ==
        '[${Level.info.name.toLowerCase()}]') {
      return kBlueColor;
    } else if (widget.logModel.level.toLowerCase() ==
        '[${Level.error.name.toLowerCase()}]') {
      return kDangerColor;
    } else if (widget.logModel.level.toLowerCase() ==
        '[${Level.warning.name.toLowerCase()}]') {
      return Colors.orange;
    } else {
      return kMainIconColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: toggleExpand,
      margin: EdgeInsets.symmetric(
        horizontal: kHPad / 2,
        vertical: kVPad / 4,
      ),
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(smallBorderRadius),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: kHPad / 2,
        vertical: kVPad / 4,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                widget.logModel.level,
                style: h3TextStyle.copyWith(
                  color: levelColor(),
                ),
              ),
              Spacer(),
              Text(
                Intl()
                    .date('yy/MM/dd hh:mm:ss aa')
                    .format(DateTime.parse(widget.logModel.dateTime)),
                style: h4TextStyleInactive,
              ),
              HSpace(),
              Transform(
                alignment: Alignment.center,
                transform: expanded
                    ? Matrix4.rotationZ(90 * (pi / 180))
                    : Matrix4.rotationZ(0),
                child: Image.asset(
                  'assets/icons/forward.png',
                  width: smallIconSize,
                  color: kMainIconColor,
                ),
              )
            ],
          ),
          if (expanded)
            Column(
              children: [
                VSpace(),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: double.infinity),
                      Text(
                        widget.logModel.message,
                        style: h4LiteTextStyle,
                      ),
                      VSpace(factor: .3),
                      HLine(
                        color: kMainIconColor.withOpacity(.3),
                        width: 2,
                      ),
                      Text(widget.logModel.error),
                      Text(widget.logModel.stackTrace),
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
