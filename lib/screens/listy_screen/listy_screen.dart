// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/listy_screen/widgets/add_listy_button.dart';
import 'package:explorer/screens/listy_screen/widgets/listy_item.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

enum OpenMode {
  normal,
  choose,
}

class ListyScreen extends StatefulWidget {
  static const String routeName = '/ListyScreen';
  const ListyScreen({super.key});

  @override
  State<ListyScreen> createState() => _ListyScreenState();
}

class _ListyScreenState extends State<ListyScreen> {
  String? path;
  EntityType? entityType;
  OpenMode openMode = OpenMode.normal;

//? to set the selected item if the open mode is choose
  void setChooseData(Map<String, dynamic> arguments) async {
    setState(() {
      path = arguments['path'] as String;
      entityType = arguments['type'] as EntityType;
      openMode = OpenMode.choose;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      Map<String, dynamic>? arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        setChooseData(arguments);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listyProvider = Provider.of<ListyProvider>(context);
    List<ListyModel> lists = openMode == OpenMode.normal
        ? [
            listyProvider.listyList.first,
            ...listyProvider.listyList
                .getRange(1, listyProvider.listyList.length)
                .toList()
                .reversed,
          ]
        : [
            ...listyProvider.listyList
                .getRange(1, listyProvider.listyList.length)
                .toList()
                .reversed,
          ];
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'listy-text'.i18n(),
              style: h2TextStyle,
            ),
            rightIcon: Row(
              children: [
                AddListyButton(),
                HSpace(),
              ],
            ),
          ),
          VSpace(),
          Expanded(
            child: lists.isEmpty
                ? Text(
                    'add-listy-from-button'.i18n(),
                    style: h4TextStyleInactive,
                  )
                : ListView(
                    physics: BouncingScrollPhysics(),
                    children: lists
                        .map(
                          (e) => ListyItem(
                            e: e,
                            openMode: openMode,
                            entityType: entityType,
                            path: path,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
