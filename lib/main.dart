// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:explorer/initiators/init.dart';
import 'package:explorer/initiators/main_providers.dart';
import 'package:explorer/initiators/main_screens.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/intro_screen/intro_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:explorer/utils/notifications/notification_contorller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:provider/provider.dart';

//! add the ability to download a folder
//! add video, audio notification
//! prevent the app from being killed when it is in the background
//!

// fix viewwing the file hint in windows
// fix continuing faild task from laptop

// fix notification still viewed after file downloaded

//! add download folder, then allow selecting for multiple downloads in sharespace viewer screen, then sorting, then" download to "
//! show the video name in video player
//! add disks_desktop 1.0.1

void startForegroundService() async {
  ForegroundService().start();
  debugPrint("Started service");
}

void main() async {
  await initBeforeRunApp();
  runApp(const MyApp());
  startForegroundService();
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

    return MultiProvider(
      providers: mainProviders,
      child: MaterialApp(
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
