// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

// fix continuing failed task from laptop

//! add disks_desktop 1.0.1

// add remaining time on the downloading card

// ForegroundService().start(); only when opening the server either with laptop or with share space
// and ForegroundService().stop(); when closing both laptop and share space, make an outside function to check for this and close the background service only when both servers are SnackBarClosedReason
// implement resuming downloads with laptop for both laptop and mobile
// try to edit the ForegroundService() package to stop sounds and to change the title of the notification
//! fix the can't generate thumbnail error, because the package name changed in the main kotlin
//! fix play_pause video button when pausing from notification or from headset, this might be fixed by moving the animation controller into the media provider like the windows version

//! try the flutterVersionCode to change it locally and update the app on the phone and see will it work or not

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
}

class _MyAppState extends State<MyApp> {
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
          //! this is just because i am not fully done yet with arabic language

          return englishLocal;
          if (supportedLocales.contains(locale)) {
            return locale;
          } else if (locale?.languageCode == arabicLocal.languageCode) {
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
