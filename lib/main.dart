// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/providers/children_info_provider.dart';
import 'package:explorer/screens/home_screen/home_screen.dart';
import 'package:explorer/screens/isolate_testing_screen/isolate_testing_screen.dart';
import 'package:explorer/screens/scanning_storage_screen/scanning_storage_screen.dart';
import 'package:explorer/screens/test_screen/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

bool testing = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChildrenItemsProvider(),
      child: MaterialApp(
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
        initialRoute:
            testing ? TestScreen.routeName : ScanningStorageScreen.routeName,
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          ScanningStorageScreen.routeName: (context) => ScanningStorageScreen(),
          TestScreen.routeName: (context) => TestScreen(),
          IsolateTestingScreen.routeName: (context) => IsolateTestingScreen(),
        },
      ),
    );
  }
}
