import 'package:explorer/constants/sizes.dart';
import 'package:flutter/material.dart';

class VLine extends StatelessWidget {
  final double? thickness;
  final Color? color;
  final double? borderRadius;
  final double? height;

  const VLine({
    Key? key,
    this.color,
    this.thickness,
    this.borderRadius,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: thickness ?? 2,
      height: height ?? kVPad,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
    );
  }
}
