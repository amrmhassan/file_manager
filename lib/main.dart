// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code, library_private_types_in_public_api

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/languages_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/initiators/init.dart';
import 'package:explorer/initiators/main_providers.dart';
import 'package:explorer/initiators/main_screens.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/utils/notifications/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
// flutter packages pub run build_runner build --delete-conflicting-outputs

//! add disks_desktop 1.0.1

// add remaining time on the downloading card

//! run parallel analyzer for the analyzer provider like in the search provider to fasten the process
//! with each extended search, deal with it as a full analyze step and use it's results to update the analyzing reports and all that stuff

void startForegroundService() {
  ForegroundService().start();
}

void stopForegroundService() {
  ForegroundService().stop();
}

void main() async {
  await initBeforeRunApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  void setLocale(Locale l) {
    setState(() {
      _locale = l;
    });
  }

  Locale? get locale => _locale;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var initialRoute = testing
        ? TestScreen.routeName
        : (firstTimeRunApp ? IntroScreen.routeName : HomeScreen.routeName);
    LocalJsonLocalization.delegate.directories = ['assets/languages'];

    return MultiProvider(
      providers: mainProviders,
      child: MaterialApp(
        locale: _locale,
        localizationsDelegates: [
          // delegate from flutter_localization
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // delegate from localization package.
          LocalJsonLocalization.delegate,
        ],
        supportedLocales: supportedLocales,
        localeResolutionCallback: (locale, supportedLocales) {
          // to check for the saved locale key
          if (loadedCurrentLocale != null) {
            Locale localeHolder = Locale.fromSubtags(
              languageCode: loadedCurrentLocale!.languageCode,
            );
            Intl.defaultLocale = localeHolder.languageCode;
            loadedCurrentLocale = null;

            return localeHolder;
          }
          Intl.defaultLocale = locale?.languageCode;
          // if (kDebugMode) {
          //   return arLocale;
          // }
          for (var l in supportedLocales) {
            if (l.languageCode.toLowerCase() ==
                locale?.languageCode.toLowerCase()) {
              return l;
            }
          }

          return enLocale;
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Cairo',
              color: kActiveTextColor,
            ),
          ),
        ),
        initialRoute: initialRoute,
        navigatorKey: navigatorKey,
        routes: mainRoutes,
      ),
    );
  }
}
