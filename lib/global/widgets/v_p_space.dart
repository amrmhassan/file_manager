import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/cupertino.dart';

//? to make a vertical space depending on the screen height
class VPSpace extends StatelessWidget {
  final int percentage;
  const VPSpace({
    Key? key,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.getHeightPercentage(context, percentage),
    );
  }
}
