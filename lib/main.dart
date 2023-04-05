// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code, library_private_types_in_public_api

import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
// flutter packages pub run build_runner build --delete-conflicting-outputs
// git merge -X theirs windows

// add the ability to click the section in the recent screen and direct the user to
// the corresponding section detailed data

//! add disks_desktop 1.0.1

// add remaining time on the downloading card

//! run parallel analyzer for the analyzer provider like in the search provider to fasten the process
//! with each extended search, deal with it as a full analyze step and use it's results to update the analyzing reports and all that stuff

//! close server if the scan qr view screen disposed  without any connection

//! make a header to be
//sent with each request to know if the other device will be used to share or not

//! add help screen
//! make a video for the app on google play
//! change intro screens for laptop and android
//! make announcement of the new sharing techniques that the laptop can share to laptop and can connect to a group like a normal device

//@ add a third screen next to recent screen and explorer screen to view the share screen and add an icon for it

//@
//@
//@
//@ for the auto connect thing, this will be only between laptop and a device
//@ and you can add an endpoint in the beacon server which will listen for auto connect calls
//@ and the client device will provide his id and name
//@ and there will be special permission for that of course
//@ you will need to run the beacon server once the laptop app started

//! add system_tray package to hide the app instead of closing it
//! before deploying, just change the app name, make a video for the app, make a mockup for the app images on google play, add crashlytics to desktop app

void startForegroundService() {
  ForegroundService().start();
}

void stopForegroundService() {
  ForegroundService().stop();
}

void main() async {
  await AppInit.init();
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
  Future<void> _initializePlatformState() async {
    // Listen for the platform-specific system events
    SystemChannels.platform.setMethodCallHandler((MethodCall methodCall) async {
      logger.i(methodCall.method);
      if (methodCall.method == 'SystemNavigator.pop') {
        // Prevent the app from closing when the user tries to close it from the taskbar
        appWindow.hide();
      }
    });
  }

  @override
  void initState() {
    if (Platform.isWindows) {
      _initializePlatformState();
    }
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
