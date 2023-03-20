// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:flutter/material.dart';

class LanguageModal extends StatelessWidget {
  const LanguageModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      bottomPaddingFactor: 0,
      afterLinePaddingFactor: 0,
      padding: EdgeInsets.symmetric(vertical: largePadding, horizontal: kHPad),
      showTopLine: false,
      color: kCardBackgroundColor,
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'العربية',
              style: h3TextStyle,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text(
              'English',
              style: h3TextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
