// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class DoubleButtonsModal extends StatelessWidget {
  final String title;
  final String? subTitle;
  final VoidCallback onOk;
  final VoidCallback? onCancel;
  final String? okText;
  final String? cancelText;
  final Color? okColor;
  final Color? cancelColor;

  const DoubleButtonsModal({
    Key? key,
    required this.onOk,
    required this.title,
    this.onCancel,
    this.subTitle,
    this.okText,
    this.cancelText,
    this.okColor,
    this.cancelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      showTopLine: false,
      color: kCardBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: h3TextStyle,
              ),
            ],
          ),
          if (subTitle != null)
            Row(
              children: [
                Text(
                  subTitle.toString(),
                  style: h4TextStyleInactive,
                ),
              ],
            ),
          VSpace(),
          Row(
            children: [
              Expanded(
                child: ButtonWrapper(
                  onTap: () {
                    if (onCancel != null) onCancel!();
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: kHPad / 2, vertical: kVPad / 2),
                  backgroundColor: cancelColor ?? kBackgroundColor,
                  child: Text(
                    cancelText ?? 'Cancel',
                    style: h4TextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
              HSpace(),
              Expanded(
                child: ButtonWrapper(
                  onTap: () {
                    onOk();
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: kHPad / 2, vertical: kVPad / 2),
                  backgroundColor: okColor ?? kDangerColor,
                  child: Text(
                    okText ?? 'Delete',
                    style: h4TextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
