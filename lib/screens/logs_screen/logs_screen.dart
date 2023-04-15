// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/initiators/global_runtime_variables.dart';
import 'package:flutter/material.dart';

class LogsScreen extends StatefulWidget {
  static const String routeName = '/LogsScreen';
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  bool loading = false;
  String? content;
  StreamSubscription? watchSub;
  ScrollController _scrollController = ScrollController();

  void loadLogs([bool allowLoading = true]) async {
    setState(() {
      if (allowLoading) {
        loading = true;
      }
    });
    File logFile = File(logFilePath);
    if (!logFile.existsSync()) {
      setState(() {
        loading = false;
      });
      return;
    }
    content = await logFile.readAsString();
    setState(() {
      if (allowLoading) {
        loading = false;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void deleteLogs() async {
    setState(() {
      loading = true;
    });
    File logFile = File(logFilePath);
    if (logFile.existsSync()) {
      logFile.deleteSync();
    }
    content = null;
    setState(() {
      loading = false;
    });
  }

  void runFileWatcher() {
    File file = File(logFilePath);
    if (file.existsSync()) {
      watchSub = file.watch().listen((event) {
        loadLogs(false);
      });
    } else {
      Future.delayed(Duration(seconds: 1)).then((value) {
        if (!mounted) return;
        runFileWatcher();
      });
    }
  }

  @override
  void initState() {
    loadLogs();
    runFileWatcher();
    super.initState();
  }

  @override
  void dispose() {
    watchSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Logs File',
              style: h2TextStyle,
            ),
            rightIcon: IconButton(
              onPressed: deleteLogs,
              icon: Icon(
                Icons.delete,
                color: kDangerColor,
              ),
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: kMainIconColor,
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Text(content ?? 'Empty Logs'),
                  ),
                )
        ],
      ),
    );
  }
}
