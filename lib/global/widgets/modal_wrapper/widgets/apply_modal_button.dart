// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class ApplyModalButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool active;
  final Color? color;

  const ApplyModalButton({
    Key? key,
    required this.onTap,
    required this.title,
    this.active = true,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      active: active,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: kVPad / 2),
      onTap: onTap,
      child: Text(
        title,
        style: h3LiteTextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
