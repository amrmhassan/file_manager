//? localization
import 'package:flutter/material.dart';

Locale arLocale = const Locale('ar');
Locale enLocale = const Locale('en');
Locale beLocale = const Locale('be');
Locale bgLocale = const Locale('bg');
Locale bnLocale = const Locale('bn');
Locale cyLocale = const Locale('cy');
Locale deLocale = const Locale('de');
Locale eeLocale = const Locale('ee');
Locale esLocale = const Locale('es');
Locale fiLocale = const Locale('fi');
Locale frLocale = const Locale('fr');
Locale hiLocale = const Locale('hi');
Locale hrLocale = const Locale('hr');
Locale huLocale = const Locale('hu');
Locale idLocale = const Locale('id');
Locale isLocale = const Locale('is');
Locale itLocale = const Locale('it');
Locale jaLocale = const Locale('ja');
Locale ltLocale = const Locale('lt');
Locale lvLocale = const Locale('lv');
Locale mkLocale = const Locale('mk');
Locale mtLocale = const Locale('mt');
Locale nlLocale = const Locale('nl');
Locale noLocale = const Locale('no');
Locale paLocale = const Locale('pa');
Locale plLocale = const Locale('pl');
Locale ptLocale = const Locale('pt');
Locale roLocale = const Locale('ro');
Locale ruLocale = const Locale('ru');
Locale siLocale = const Locale('si');
Locale skLocale = const Locale('sk');
Locale smLocale = const Locale('sm');
Locale sqLocale = const Locale('sq');
Locale svLocale = const Locale('sv');
Locale trLocale = const Locale('tr');
Locale zhLocale = const Locale('zh');

List<Locale> supportedLocales = [
  arLocale,
  enLocale,
  bgLocale,
  bnLocale,
  cyLocale,
  deLocale,
  eeLocale,
  esLocale,
  fiLocale,
  frLocale,
  hiLocale,
  hrLocale,
  huLocale,
  idLocale,
  isLocale,
  itLocale,
  jaLocale,
  ltLocale,
  lvLocale,
  mkLocale,
  mtLocale,
  nlLocale,
  noLocale,
  paLocale,
  plLocale,
  ptLocale,
  roLocale,
  ruLocale,
  siLocale,
  skLocale,
  smLocale,
  sqLocale,
  svLocale,
  trLocale,
  zhLocale,
];

Map<String, String> getLanguageNames(List<Locale> locales) {
  Map<String, String> languageNameMap = {};

  for (Locale locale in locales) {
    String languageCode = locale.languageCode;
    String languageName;

    switch (languageCode) {
      case 'ar':
        languageName = 'العربية';
        break;
      case 'en':
        languageName = 'English';
        break;
      case 'be':
        languageName = 'беларуская мова';
        break;
      case 'bg':
        languageName = 'български език';
        break;
      case 'bn':
        languageName = 'বাংলা';
        break;
      case 'cy':
        languageName = 'Cymraeg';
        break;
      case 'de':
        languageName = 'Deutsch';
        break;
      case 'ee':
        languageName = 'Eʋegbe';
        break;
      case 'es':
        languageName = 'Español';
        break;
      case 'fi':
        languageName = 'Suomi';
        break;
      case 'fr':
        languageName = 'Français';
        break;
      case 'hi':
        languageName = 'हिन्दी';
        break;
      case 'hr':
        languageName = 'Hrvatski';
        break;
      case 'hu':
        languageName = 'Magyar';
        break;
      case 'id':
        languageName = 'Bahasa Indonesia';
        break;
      case 'is':
        languageName = 'Íslenska';
        break;
      case 'it':
        languageName = 'Italiano';
        break;
      case 'ja':
        languageName = '日本語';
        break;
      case 'lt':
        languageName = 'Lietuvių kalba';
        break;
      case 'lv':
        languageName = 'Latviešu valoda';
        break;
      case 'mk':
        languageName = 'Македонски јазик';
        break;
      case 'mt':
        languageName = 'Malti';
        break;
      case 'nl':
        languageName = 'Nederlands';
        break;
      case 'no':
        languageName = 'Norsk';
        break;
      case 'pa':
        languageName = 'ਪੰਜਾਬੀ';
        break;
      case 'pl':
        languageName = 'Język polski';
        break;
      case 'pt':
        languageName = 'Português';
        break;
      case 'ro':
        languageName = 'Română';
        break;
      case 'ru':
        languageName = 'Русский язык';
        break;
      case 'si':
        languageName = 'සිංහල';
        break;
      case 'sk':
        languageName = 'Slovenčina';
        break;
      case 'sm':
        languageName = 'Gagana fa\'a Samoa';
        break;
      case 'sq':
        languageName = 'Shqip';
        break;
      case 'sv':
        languageName = 'Svenska';
        break;
      case 'tr':
        languageName = 'Türkçe';
        break;
      case 'zh':
        languageName = '中文';
        break;
      default:
        languageName = 'Unknown';
    }
    languageNameMap[languageCode] = languageName;
  }
  return languageNameMap;
}
