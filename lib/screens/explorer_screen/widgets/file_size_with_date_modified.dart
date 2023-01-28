import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileSizeWithDateModified extends StatelessWidget {
  const FileSizeWithDateModified({
    Key? key,
    required this.size,
    required this.hasData,
    required this.modified,
  }) : super(key: key);

  final int? size;
  final bool hasData;
  final DateTime? modified;

  String? fileSizeString() =>
      (size == null || size == -1) ? null : handleConvertSize(size!);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (fileSizeString() != null)
          Text(
            fileSizeString()!,
            style: h4TextStyleInactive.copyWith(
              color: kInactiveColor,
              height: 1,
            ),
          ),
        if (hasData)
          if (modified != null)
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
                  DateFormat('yyyy-MM-dd').format(modified!),
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
