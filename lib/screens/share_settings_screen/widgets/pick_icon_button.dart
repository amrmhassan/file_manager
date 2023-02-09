// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:flutter/material.dart';

class PickMyIconButton extends StatelessWidget {
  const PickMyIconButton({
    super.key,
  });

  void pickMyPhoto(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ModalWrapper(
        child: Row(
          children: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWrapper(
          onTap: () => pickMyPhoto(context),
          padding: EdgeInsets.symmetric(
            horizontal: kHPad,
            vertical: kVPad / 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: kMainIconColor.withOpacity(.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(smallBorderRadius),
          ),
          child: Text(
            'Edit',
            style: h4TextStyle.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
