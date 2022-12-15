// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListyScreen extends StatelessWidget {
  static const String routeName = '/ListyScreen';
  const ListyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var listyProvider = Provider.of<ListyProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Listy',
              style: h2TextStyle,
            ),
            rightIcon: Row(
              children: [
                ButtonWrapper(
                  width: largeIconSize,
                  height: largeIconSize,
                  onTap: () {
                    createNewFolderModal(context, true);
                  },
                  child: Image.asset(
                    'assets/icons/plus.png',
                    color: kMainIconColor,
                    width: largeIconSize / 2,
                  ),
                ),
                HSpace(),
              ],
            ),
          ),
          VSpace(),
          Expanded(
              child: ListView(
            children: listyProvider.listyList
                .map(
                  (e) => AnalyzerOptionsItem(
                    onTap: () {},
                    title: e.title,
                    iconPath: e.icon,
                    logoName: '',
                    // color: kMainIconColor,
                  ),
                )
                .toList(),
          ))
        ],
      ),
    );
  }
}
