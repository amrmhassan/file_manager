// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/extension_info.dart';
import 'package:explorer/global/table/table_header.dart';
import 'package:explorer/global/table/table_row.dart';
import 'package:explorer/screens/ext_files_screen/ext_files_screen.dart';
import 'package:explorer/screens/ext_report_screen/ext_report_screen.dart';
import 'package:flutter/material.dart';

class ExtensionsTable extends StatelessWidget {
  final List<ExtensionInfo> arrangedList;
  final SortParameter sortParameter;
  final Function(SortParameter sp) setSortParameter;
  const ExtensionsTable({
    Key? key,
    required this.arrangedList,
    required this.sortParameter,
    required this.setSortParameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTableHeader(
          setSortParameter: setSortParameter,
          sortParameter: sortParameter,
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ...arrangedList
                  .asMap()
                  .entries
                  .map(
                    (entry) => CustomTableRow(
                      entry: entry,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ExtFilesScreen.routeName,
                          arguments: {
                            'ext': entry.value.ext,
                            'size': entry.value.size,
                          },
                        );
                      },
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ],
    );
  }
}
