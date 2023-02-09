// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String title;
  final String? iconName;
  final Function(String v)? onChange;
  final String? trailingIconName;
  final Widget? trailingIconWidget;
  final Color? color;
  final Color? borderColor;
  final EdgeInsets? padding;
  final Color? trailingIconColor;
  final bool autoFocus;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final bool password;
  final VoidCallback? handleShowPassword;
  final TextInputAction? textInputAction;
  final String? errorText;
  final String? Function(String? v)? validator;
  final bool enabled;
  final TextStyle? textStyle;
  final bool? requiredField;
  final BorderRadius? borderRadius;
  final int? maxLines;
  final int? minLines;
  final String? initialValue;
  final Widget? trailingIcon;
  final int? maxLength;
  final Widget? Function(BuildContext,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? buildCounter;
  const CustomTextField({
    Key? key,
    this.iconName,
    required this.title,
    this.onChange,
    this.trailingIconName,
    this.color,
    this.borderColor,
    this.padding,
    this.trailingIconWidget,
    this.trailingIconColor,
    this.autoFocus = false,
    this.controller,
    this.textInputType,
    this.password = false,
    this.handleShowPassword,
    this.textInputAction,
    this.errorText,
    this.validator,
    this.enabled = true,
    this.textStyle,
    this.requiredField,
    this.borderRadius,
    this.maxLines,
    this.minLines,
    this.initialValue,
    this.trailingIcon,
    this.maxLength,
    this.buildCounter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaddingWrapper(
      padding: padding ?? EdgeInsets.symmetric(horizontal: kHPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (requiredField == true)
                Text(
                  '*',
                  style: TextStyle(
                    height: 1,
                    color: kDangerColor,
                    fontSize: h2TextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ??
                        BorderRadius.circular(smallBorderRadius),
                    border: Border.all(
                      width: 1,
                      color: errorText == null
                          ? (borderColor ?? kInactiveColor)
                          : kDangerColor,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: kHPad / 2,
                    // vertical: kVPad / 2,
                  ),
                  child: Row(
                    children: [
                      if (iconName != null)
                        Image.asset(
                          'assets/icons/$iconName.png',
                          width: mediumIconSize,
                          color: errorText == null
                              ? (color ?? kInactiveColor)
                              : kDangerColor,
                        ),
                      HSpace(factor: .5),
                      Expanded(
                        child: TextFormField(
                          maxLength: maxLength,
                          maxLines: maxLines ?? 1,
                          buildCounter: buildCounter,
                          minLines: minLines ?? 1,
                          enabled: enabled,
                          validator: validator,
                          textInputAction:
                              textInputAction ?? TextInputAction.next,
                          obscureText: password,
                          autocorrect: !password,
                          controller: controller,
                          onChanged: onChange,
                          autofocus: autoFocus,
                          keyboardType: textInputType,
                          style: textStyle ?? h3LiteTextStyle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: title,
                            hintStyle: errorText == null
                                ? h3LiteTextStyle
                                : h3LiteTextStyle.copyWith(
                                    color: kDangerColor,
                                  ),
                          ),
                        ),
                      ),
                      if (trailingIcon != null) trailingIcon!,
                      if (trailingIconName != null)
                        GestureDetector(
                          onTap: handleShowPassword,
                          child: Image.asset(
                            'assets/icons/$trailingIconName.png',
                            width: mediumIconSize,
                            color: trailingIconColor ?? kInactiveColor,
                          ),
                        ),
                      if (trailingIconWidget != null) trailingIconWidget!
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (errorText != null)
            Text(
              errorText.toString(),
              style: h4LiteTextStyle.copyWith(color: kDangerColor),
            ),
        ],
      ),
    );
  }
}
