// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SearchingOrExtendSearch extends StatelessWidget {
  const SearchingOrExtendSearch({super.key});

  @override
  Widget build(BuildContext context) {
    var searchProviderFalse = searchPF(context);
    var searchProvider = searchP(context);
    if (searchProvider.searching) {
      return PaddingWrapper(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('searching'.i18n()),
            Spacer(),
            SizedBox(
              width: smallIconSize,
              height: smallIconSize,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      );
    } else if (!searchProvider.extendSearchDone) {
      return PaddingWrapper(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonWrapper(
              onTap: () {
                searchProviderFalse.extendedSearch();
              },
              child: Text(
                'extended-search'.i18n(),
                style: h4TextStyle.copyWith(color: kBlueColor),
              ),
            ),
            Spacer(),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
