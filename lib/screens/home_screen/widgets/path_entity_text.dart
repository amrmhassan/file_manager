// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';

class PathEntityText extends StatelessWidget {
  final String pathEntity;
  final VoidCallback onTap;
  const PathEntityText({
    Key? key,
    required this.pathEntity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: 100),
        child: Text(
          pathEntity,
          style: h4TextStyleInactive,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
