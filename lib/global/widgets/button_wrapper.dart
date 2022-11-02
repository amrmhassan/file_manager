import 'package:flutter/material.dart';

class ButtonWrapper extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final bool splash;
  final EdgeInsets? margin;
  final Alignment? alignment;
  final Clip? clipBehavior;
  final bool active;
  final Color? inactiveColor;

  const ButtonWrapper({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.child,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius = 10,
    this.decoration,
    this.padding,
    this.splash = true,
    this.margin,
    this.alignment,
    this.clipBehavior,
    this.active = true,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      alignment: alignment,
      margin: margin,
      decoration: decoration ??
          BoxDecoration(
            color: active
                ? (backgroundColor ?? Colors.transparent)
                : (inactiveColor) ??
                    (backgroundColor?.withOpacity(.2) ??
                        Colors.transparent.withOpacity(.2)),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onLongPress: onLongPress,
          onTap: active ? onTap : null,
          child: Container(
            //! this caused a UI error, if something like that happened again just fix this line
            alignment: alignment ?? Alignment.center,
            padding: padding,
            width: width,
            height: height,
            child: child,
          ),
        ),
      ),
    );
  }
}
