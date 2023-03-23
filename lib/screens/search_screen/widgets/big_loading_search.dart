// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class BigLoadingSearch extends StatelessWidget {
  const BigLoadingSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Text(
            'Searching...',
            style: h4TextStyleInactive,
          ),
          VSpace(factor: .5),
          SizedBox(
            width: largeIconSize,
            height: largeIconSize,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
  }
}
