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
  final Border? border;
  final VoidCallback? onDoubleTapped;
  final Color? hoverColor;
  final Color? focusedColor;
  final double? opacity;
  final bool minimumSpace;

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
    this.border,
    this.onDoubleTapped,
    this.hoverColor,
    this.focusedColor,
    this.opacity,
    this.minimumSpace = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonWidget = Opacity(
      opacity: opacity ?? 1,
      child: Container(
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
              border: border,
            ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            hoverColor: hoverColor,
            focusColor: focusedColor,
            onDoubleTap: onDoubleTapped,
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
      ),
    );
    return minimumSpace
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonWidget,
                ],
              ),
            ],
          )
        : buttonWidget;
  }
}
