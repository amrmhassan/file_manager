import 'package:flutter/material.dart';

class HSpace extends StatelessWidget {
  final double factor;
  const HSpace({Key? key, this.factor = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20 * factor);
  }
}
