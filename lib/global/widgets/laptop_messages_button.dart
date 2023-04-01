// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/screens/laptop_messages_screen/laptop_messages_screen.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class MessagesButton extends StatelessWidget {
  const MessagesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var msgProvider = msgP(context);

    return (msgProvider.notViewedMessages.isNotEmpty &&
            ModalRoute.of(context)?.settings.name !=
                LaptopMessagesScreen.routeName)
        ? Positioned(
            bottom: Responsive.getHeight(context) / 5,
            right: 0,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ButtonWrapper(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      LaptopMessagesScreen.routeName,
                    );
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
                    'assets/icons/laptop-color.png',
                  ),
                ),
                Positioned(
                  top: -10,
                  left: -10,
                  child: Container(
                    alignment: Alignment.center,
                    width: mediumIconSize,
                    height: mediumIconSize,
                    decoration: BoxDecoration(
                      color: kCardBackgroundColor,
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      msgProvider.notViewedMessages.length.toString(),
                      style: h4LightTextStyle.copyWith(height: 1),
                    ),
                  ),
                )
              ],
            ),
          )
        : SizedBox();
  }
}
