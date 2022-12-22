// ignore_for_file: prefer_const_constructors

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/providers/util/analyzer_provider.dart';
import 'package:explorer/global/widgets/table/extensions_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//? asc means the smallest first
//? desc means the largest first
enum SortParameter {
  nameAsc,
  nameDesc,
  countAsc,
  countDesc,
  sizeAsc,
  sizeDesc,
}

enum HeaderItem {
  name,
  count,
  size,
}

class ExtReportScreen extends StatefulWidget {
  static const String routeName = '/ext-report-screen';
  const ExtReportScreen({super.key});

  @override
  State<ExtReportScreen> createState() => _ExtReportScreenState();
}

class _ExtReportScreenState extends State<ExtReportScreen> {
  SortParameter sortParameter = SortParameter.sizeDesc;

  void setSortParameter(SortParameter sp) {
    setState(() {
      sortParameter = sp;
    });
  }

  List<ExtensionInfo> getArrangedExtInfo(SortParameter sortParameter) {
    var analyzerProvider =
        Provider.of<AnalyzerProvider>(context, listen: false);
    List<ExtensionInfo> list = analyzerProvider.allExtensionInfo!;
    if (sortParameter == SortParameter.sizeDesc) {
      list.sort(
        (a, b) => b.size.compareTo(a.size),
      );
    } else if (sortParameter == SortParameter.sizeAsc) {
      list.sort(
        (a, b) => a.size.compareTo(b.size),
      );
    } else if (sortParameter == SortParameter.nameDesc) {
      list.sort(
        (a, b) => a.ext.compareTo(b.ext),
      );
    } else if (sortParameter == SortParameter.nameAsc) {
      list.sort(
        (a, b) => b.ext.compareTo(a.ext),
      );
    } else if (sortParameter == SortParameter.countDesc) {
      list.sort(
        (a, b) => b.count.compareTo(a.count),
      );
    } else if (sortParameter == SortParameter.countAsc) {
      list.sort(
        (a, b) => a.count.compareTo(b.count),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          Expanded(
            child: ExtensionsTable(
              arrangedList: getArrangedExtInfo(sortParameter),
              sortParameter: sortParameter,
              setSortParameter: setSortParameter,
            ),
          ),
        ],
      ),
    );
  }
}
