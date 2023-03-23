// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/pick_image_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class PickMyIconButton extends StatelessWidget {
  const PickMyIconButton({
    super.key,
  });

  void pickMyPhoto(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return PickImageModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
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
            shareProvider.myImagePath == null
                ? 'add-image'.i18n()
                : 'edit'.i18n(),
            style: h4TextStyle.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        if (shareProvider.myImagePath != null)
          Row(
            children: [
              HSpace(),
              ButtonWrapper(
                onTap: () => sharePF(context).removeImagePath(),
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
                  'clear'.i18n(),
                  style: h4TextStyle.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
