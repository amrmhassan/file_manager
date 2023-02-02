// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/screens/error_viewing_screen/widgets/error_card.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/errors_collection/error_logger_model.dart';
import 'package:flutter/material.dart';

class ErrorViewScreen extends StatefulWidget {
  static const String routeName = '/ErrorViewScreen';
  const ErrorViewScreen({super.key});

  @override
  State<ErrorViewScreen> createState() => _ErrorViewScreenState();
}

class _ErrorViewScreenState extends State<ErrorViewScreen> {
  List<ErrorLoggerModel> errorsList = [];
  bool loading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      var errors = await customLogger.loadAllErrors();
      setState(() {
        errorsList = errors;
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.white,
                    ),
                  )
                : ListView.builder(
                    itemCount: errorsList.length,
                    itemBuilder: (context, index) => ErrorCard(
                      errorLoggerModel: errorsList[index],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
