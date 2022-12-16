// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/explorer_tabs/widgets/single_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerTabs extends StatelessWidget {
  const ExplorerTabs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    return expProvider.tabs.isEmpty
        ? SizedBox()
        : Container(
            width: double.infinity,
            // height: kVPad * 2,
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: kBackgroundColor,
                ),
              ),
            ),
            child: SizedBox(
              height: kVPad * 1.5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...expProvider.tabs.map((e) => SingleTab(tabModel: e))
                ],
              ),
            ),
          );
  }
}
