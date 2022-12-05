import 'package:explorer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  final Color? baseColor;
  final Color? lightColor;
  final Widget child;
  const ShimmerWrapper({
    super.key,
    this.baseColor,
    this.lightColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? shimmerBaseColor,
      highlightColor: lightColor ?? shimmerLightColor,
      child: child,
    );
  }
}
