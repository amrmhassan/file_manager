// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ErrorCard extends StatefulWidget {
  final ErrorLoggerModel errorLoggerModel;
  const ErrorCard({
    super.key,
    required this.errorLoggerModel,
  });

  @override
  State<ErrorCard> createState() => _ErrorCardState();
}

class _ErrorCardState extends State<ErrorCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: kVPad / 2),
        padding: EdgeInsets.symmetric(
          horizontal: kHPad / 2,
          vertical: kVPad / 2,
        ),
        decoration: BoxDecoration(color: kCardBackgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.errorLoggerModel.error,
              style: h4TextStyle,
            ),
            if (expanded)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd hh:mm:ss aa')
                            .format(widget.errorLoggerModel.date),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                  Text(
                    widget.errorLoggerModel.stackTrace,
                    style: h3InactiveTextStyle,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
