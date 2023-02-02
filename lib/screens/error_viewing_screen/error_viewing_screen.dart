// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
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
  bool loading = true;

  void loadErrors() async {
    Future.delayed(Duration.zero).then((value) async {
      setState(() {
        loading = true;
      });
      var errors = await customLogger.loadAllErrors();
      setState(() {
        errorsList = errors.reversed.toList();
        loading = false;
      });
    });
  }

  @override
  void initState() {
    loadErrors();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            rightIcon: IconButton(
                onPressed: () async {
                  await customLogger.deleteAllErrors();
                  loadErrors();
                },
                icon: Icon(
                  Icons.delete,
                  color: kDangerColor,
                )),
            title: Text(
              'Logging',
              style: h3TextStyle,
            ),
          ),
          Expanded(
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.white,
                    ),
                  )
                : errorsList.isEmpty
                    ? Center(
                        child: Text(
                          'No Errors yet',
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
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
