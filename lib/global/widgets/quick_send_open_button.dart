// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class QuickSendOpnButton extends StatelessWidget {
  const QuickSendOpnButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var quickSendProvider = quickSP(context);

    return (quickSendProvider.httpServer != null &&
            ModalRoute.of(context)?.settings.name !=
                QrCodeViewerScreen.routeName)
        ? Positioned(
            bottom: Responsive.getHeight(context) / 5,
            left: 0,
            child: ButtonWrapper(
              onTap: () {
                Navigator.pushNamed(context, QrCodeViewerScreen.routeName,
                    arguments: quickSPF(context).fileConnLink);
              },
              padding: EdgeInsets.all(largePadding),
              width: largeIconSize * 1.5,
              height: largeIconSize * 1.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(largeBorderRadius),
                border: Border.all(
                  width: 2,
                  color: kCardBackgroundColor.withOpacity(.5),
                ),
                color: kMainIconColor.withOpacity(.2),
              ),
              child: Image.asset(
                'assets/icons/logo.png',
              ),
            ),
          )
        : SizedBox();
  }
}
