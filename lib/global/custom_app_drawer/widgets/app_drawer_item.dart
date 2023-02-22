// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppDrawerItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String? iconPath;
  final bool onlyDebug;
  final bool allowBadge;
  final String? badgeContent;
  final Color? badgeColor;

  const AppDrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.iconPath,
    this.onlyDebug = false,
    this.allowBadge = false,
    this.badgeColor,
    this.badgeContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (onlyDebug && kDebugMode) || (allowDevBoxes && kReleaseMode)
        ? ButtonWrapper(
            borderRadius: 0,
            onTap: onTap,
            child: ListTile(
              leading: Image.asset(
                'assets/icons/${iconPath ?? 'menu'}.png',
                width: mediumIconSize,
                color: kInactiveColor,
              ),
              title: Text(
                title,
                style: h4TextStyle.copyWith(color: kInactiveColor),
              ),
              trailing: allowBadge
                  ? Container(
                      alignment: Alignment.center,
                      width: largeIconSize * .9,
                      height: largeIconSize * .9,
                      decoration: BoxDecoration(
                        color: badgeColor ?? kBlueColor,
                        borderRadius: BorderRadius.circular(
                          1000,
                        ),
                      ),
                      child: Text(
                        badgeContent ?? '0',
                        style: h4TextStyle,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : null,
            ),
          )
        : SizedBox();
  }
}
