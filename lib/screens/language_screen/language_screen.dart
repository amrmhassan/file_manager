// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/languages_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/global_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class LanguageScreen extends StatefulWidget {
  static const String routeName = '/LanguageScreen';
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late Map<String, String> languageMap;
  @override
  void initState() {
    languageMap = getLanguageNames(supportedLocales);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text('change-language'.i18n()),
          ),
          VSpace(),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: supportedLocales.length,
              itemBuilder: (context, index) {
                var locale = supportedLocales[index];
                return ListTile(
                  onTap: () {
                    CustomLocale.changeLocale(context, locale);
                    // CustomLocale.changeLocale(context, enLocale);
                    showSnackBar(
                      context: context,
                      message: "apply-on-next-startup".i18n(),
                    );
                  },
                  title: Text(
                    languageMap[locale.languageCode] ?? 'Unknown',
                    style: h4TextStyleInactive,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
