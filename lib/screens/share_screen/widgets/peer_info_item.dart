import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';

class PeerInfoItem extends StatelessWidget {
  final String title;
  final String value;
  const PeerInfoItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: h4TextStyle,
        ),
        Text(
          value,
          style: h4TextStyleInactive,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
