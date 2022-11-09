// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class AnalyzingReport extends StatelessWidget {
  const AnalyzingReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    // var arrangedList = [...analyzerProvider.storageAnalyserV4!.allFoldersInfo];

    return Column(
      children: [
        VSpace(),
        // Expanded(
        //   child: ExtensionsTable(arrangedList: arrangedList),
        // ),
      ],
    );
  }
}
