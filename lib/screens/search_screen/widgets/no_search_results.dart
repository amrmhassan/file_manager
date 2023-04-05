import 'package:explorer/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class NoSearchResults extends StatelessWidget {
  const NoSearchResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no-search-results'.i18n(),
        style: h4TextStyleInactive,
      ),
    );
  }
}
