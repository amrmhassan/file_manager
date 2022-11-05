// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/helpers/advanced_storage_analyzer.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class ScanningStorageScreen extends StatefulWidget {
  static const String routeName = '/ScanningStorageScreen';
  const ScanningStorageScreen({super.key});

  @override
  State<ScanningStorageScreen> createState() => _ScanningStorageScreenState();
}

class _ScanningStorageScreenState extends State<ScanningStorageScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (loading)
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              TextButton(
                onPressed: () async {
                  var obj = AdvancedStorageAnalyzer('sdcard/');
                  setState(() {
                    loading = true;
                  });
                  obj.startAnalyzing(
                    onAllDone: () {
                      setState(() {
                        loading = false;
                      });
                      var filesInfo = obj.filesInfo;
                      var foldersInfo = obj.foldersInfo;
                      printOnDebug('All Done');
                      printOnDebug('This folder has ${filesInfo.length} files');
                      printOnDebug(
                          'This folder has ${foldersInfo.length} sub-folders');
                      printOnDebug('Time Taken ${obj.timeTaken / 1000} s');
                    },
                    onFolderDone: ((localFolderInfo) {}),
                    onError: (e, dir) {},
                  );
                },
                child: Text('Analyze Storage'),
              ),
            ],
          ),
        ));
  }
}
