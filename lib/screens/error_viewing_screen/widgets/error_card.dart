import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(color: kCardBackgroundColor),
        child: Column(
          children: [
            Text(
              widget.errorLoggerModel.error,
              style: h4TextStyleInactive,
            ),
            if (expanded)
              Text(
                widget.errorLoggerModel.stackTrace,
                style: h3InactiveTextStyle,
              ),
          ],
        ),
      ),
    );
  }
}
