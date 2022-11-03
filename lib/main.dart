// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

bool testing = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Cairo',
            color: kActiveTextColor,
          ),
          bodyText2: TextStyle(
            fontFamily: 'Cairo',
            color: kActiveTextColor,
          ),
        ),
      ),
      initialRoute: testing ? TestScreen.routeName : HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        TestScreen.routeName: (context) => TestScreen(),
      },
    );
  }
}
