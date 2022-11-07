// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_count.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/screens/extension_report_screen/extension_report_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class ExtensionsTable extends StatelessWidget {
  const ExtensionsTable({
    Key? key,
    required this.arrangedList,
  }) : super(key: key);

  final List<ExtensionInfo> arrangedList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        TableHeader(titles: ['Extension', 'Count', 'Size']),
        ...arrangedList
            .asMap()
            .entries
            .map(
              (entry) => TableRow(
                entry: entry,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ExtensionReportScreen.routeName,
                    arguments: {
                      'ext': entry.value.ext,
                      'size': entry.value.size,
                    },
                  );
                },
              ),
            )
            .toList()
      ],
    );
  }
}

class TableRow extends StatelessWidget {
  final MapEntry<int, ExtensionInfo> entry;
  final VoidCallback? onTap;
  const TableRow({
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
                    color: Colors.white,
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

class TableHeader extends StatelessWidget {
  final List<String> titles;
  final Color? backgroungColor;
  final VoidCallback? onTap;

  const TableHeader({
    Key? key,
    required this.titles,
    this.backgroungColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: onTap,
      backgroundColor: backgroungColor,
      child: PaddingWrapper(
        padding:
            EdgeInsets.symmetric(horizontal: kHPad / 2, vertical: kVPad / 2),
        child: Row(
          children: [
            ...titles.asMap().entries.map(
                  (e) => Expanded(
                    child: Container(
                      alignment: e.key == 0
                          ? Alignment.centerLeft
                          : e.key == titles.length - 1
                              ? Alignment.centerRight
                              : Alignment.center,
                      child: Text(
                        e.value,
                        style: h4TextStyleInactive.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
