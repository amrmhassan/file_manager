import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.onTap,
    required this.iconData,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          onPressed: onTap,
          splashColor: Colors.white.withOpacity(.5),
          icon: Icon(
            iconData,
            color: color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
