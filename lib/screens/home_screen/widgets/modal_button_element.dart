// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:flutter/material.dart';

class ModalButtonElement extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool active;
  final Color? inactiveColor;
  final double? opacity;

  const ModalButtonElement({
    Key? key,
    required this.title,
    required this.onTap,
    this.inactiveColor,
    this.active = true,
    this.opacity,
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
          child: Text(
            title,
            style: h4TextStyleInactive.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        HLine(
          color: kInactiveColor.withOpacity(.2),
          thickness: 1,
        ),
      ],
    );
  }
}
