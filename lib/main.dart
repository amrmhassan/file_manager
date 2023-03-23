// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/initiators/init.dart';
import 'package:explorer/initiators/main_providers.dart';
import 'package:explorer/initiators/main_screens.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/utils/notifications/notification_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

// fix continuing failed task from laptop

//! add disks_desktop 1.0.1

// add remaining time on the downloading card

//! try the flutterVersionCode to change it locally and update the app on the phone and see will it work or not

//! fix playing another media when video player is open

//! continue downloading failed tasks with laptop continueFailedTasks from download provider and remove laptop_id constant and name

//! continue automatically adding recent files
//! try to make the recent files automatically connected to the list in the recent provider, to update once a file added to recent files

//!
//!
//! run parallel analyzer for the analyzer provider like in the search provider to fasten the process
//! with each extended search, deal with it as a full analyze step and use it's results to update the analyzing reports and all that stuff
//! allow opening new tab when clicking a search result folder
//! show selection controller in the search screen

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
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

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
          if (kDebugMode) {
            return arabicLocal;
          }
          _locale ??= (locale ?? englishLocal);
          //! this is just because i am not fully done yet with arabic language

          // return arabicLocal;
          if (supportedLocales.contains(_locale)) {
            return _locale;
          } else if (_locale?.languageCode == arabicLocal.languageCode) {
            return arabicLocal;
          } else {
            return englishLocal;
          }
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
