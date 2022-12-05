// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class CustomTableRow extends StatelessWidget {
  final MapEntry<int, ExtensionInfo> entry;
  final VoidCallback? onTap;
  const CustomTableRow({
    Key? key,
    required this.entry,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: onTap,
      backgroundColor:
          entry.key.isOdd ? kBackgroundColor : kCardBackgroundColor,
      child: PaddingWrapper(
        padding:
            EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  entry.value.ext.isEmpty ? 'No Extension' : entry.value.ext,
                  style: h4TextStyleInactive.copyWith(
                    color: kActiveTextColor.withOpacity(.7),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  entry.value.count.toString(),
                  style: h4TextStyleInactive,
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  handleConvertSize(entry.value.size),
                  style: h4TextStyleInactive,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
