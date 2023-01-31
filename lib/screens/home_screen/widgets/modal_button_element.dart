// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:flutter/material.dart';

class ModalButtonElement extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool active;
  final Color? inactiveColor;
  final double? opacity;
  final bool? checked;
  final bool showBottomLine;

  const ModalButtonElement({
    Key? key,
    required this.title,
    required this.onTap,
    this.inactiveColor,
    this.active = true,
    this.opacity,
    this.checked,
    this.showBottomLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWrapper(
          inactiveColor: inactiveColor,
          active: active,
          opacity: opacity,
          borderRadius: 0,
          padding: EdgeInsets.symmetric(
            horizontal: kHPad / 1.2,
            vertical: kVPad / 2,
          ),
          onTap: onTap,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                title,
                style: h4TextStyleInactive.copyWith(
                  color: kActiveTextColor,
                ),
              ),
              Spacer(),
              if (checked != null) CustomCheckBox(checked: checked),
            ],
          ),
        ),
        if (showBottomLine)
          HLine(
            color: kInactiveColor.withOpacity(.2),
            thickness: 1,
          ),
      ],
    );
  }
}
