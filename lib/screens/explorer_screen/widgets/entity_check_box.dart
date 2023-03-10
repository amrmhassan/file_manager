// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:flutter/material.dart';

class EntityCheckBox extends StatelessWidget {
  const EntityCheckBox({
    Key? key,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 600,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splash: false,
      focusedColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(largePadding),
        child: Container(
          padding: EdgeInsets.all(mediumPadding),
          width: largeIconSize / 2,
          height: largeIconSize / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(500),
            color: isSelected ? kBlueColor : Colors.transparent,
            border: Border.all(
              color: isSelected ? kBlueColor : kInactiveColor,
              width: 1,
            ),
          ),
          child: isSelected
              ? Image.asset(
                  'assets/icons/check.png',
                  color: Colors.white,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
