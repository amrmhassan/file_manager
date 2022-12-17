// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/explorer_tabs/widgets/single_tab.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExplorerTabs extends StatelessWidget {
  ExplorerTabs({
    Key? key,
  }) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  _scrollToRight() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollToRight();
    var expProvider = Provider.of<ExplorerProvider>(context);
    return expProvider.tabs.length < 2
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
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                children: [
                  HSpace(),
                  ...expProvider.tabs.map((e) => SingleTab(tabModel: e)),
                  HSpace(),
                ],
              ),
            ),
          );
  }
}
