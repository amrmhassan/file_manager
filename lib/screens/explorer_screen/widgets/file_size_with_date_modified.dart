import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileSizeWithDateModified extends StatelessWidget {
  const FileSizeWithDateModified({
    Key? key,
    required this.fileSize,
    required this.hasData,
    required this.modified,
  }) : super(key: key);

  final String fileSize;
  final bool hasData;
  final DateTime modified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          fileSize,
          style: h4TextStyleInactive.copyWith(
            color: kInactiveColor,
            height: 1,
          ),
        ),
        if (hasData)
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
                DateFormat('yyyy-MM-dd').format(modified),
                style: h4TextStyleInactive.copyWith(
                  color: kInactiveColor,
                  height: 1,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
