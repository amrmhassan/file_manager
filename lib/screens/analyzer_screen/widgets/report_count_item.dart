// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCountItem extends StatelessWidget {
  final String title;
  final double count;
  final String? trailing;

  const ReportCountItem({
    Key? key,
    required this.title,
    required this.count,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VSpace(factor: .4),
        HLine(
          color: kInactiveColor.withOpacity(.1),
        ),
        VSpace(factor: .4),
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: h4TextStyle.copyWith(color: kInActiveTextColor),
                // .copyWith(color: Colors.white.withOpacity(.7))
              ),
            ),
            HSpace(factor: .5),
            Expanded(
              child: Text(
                NumberFormat('#,###.##${trailing ?? ''}').format(count),
                style: h4TextStyleInactive,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
