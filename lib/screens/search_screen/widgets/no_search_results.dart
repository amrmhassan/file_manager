import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Search Results!',
        style: h4TextStyleInactive,
      ),
    );
  }
}
