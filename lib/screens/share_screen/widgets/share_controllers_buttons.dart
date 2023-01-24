// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class ShareControllersButtons extends StatelessWidget {
  const ShareControllersButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.getWidth(context),
      child: PaddingWrapper(
        padding: EdgeInsets.symmetric(horizontal: kHPad * 2),
        child: Row(
          children: [
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad * 2,
                vertical: kVPad / 2,
              ),
              onTap: () {},
              backgroundColor: Colors.white,
              child: Text(
                'Host',
                style: h3TextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad * 2,
                vertical: kVPad / 2,
              ),
              onTap: () {},
              backgroundColor: kBlueColor,
              child: Text(
                'Join',
                style: h3TextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
