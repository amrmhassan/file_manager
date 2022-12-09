// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
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

  const AppDrawerItem({
    Key? key,
    required this.title,
    required this.onTap,
    this.iconPath,
    this.onlyDebug = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return onlyDebug && kDebugMode
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
            ),
          )
        : SizedBox();
  }
}
