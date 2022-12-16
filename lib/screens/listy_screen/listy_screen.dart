// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/listy_items_viewer_screen/listy_items_viewer_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
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

  //? add item to custom listy other than favorite
  Future addToOtherListy(String listyTitle, String p, EntityType e) async {
    try {
      await Provider.of<ListyProvider>(context, listen: false).addItemToListy(
        path: p,
        listyTitle: listyTitle,
        entityType: e,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }

    Navigator.pop(context);
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
              physics: BouncingScrollPhysics(),
              children: lists
                  .map(
                    (e) => Column(
                      children: [
                        AnalyzerOptionsItem(
                          onTap: openMode == OpenMode.normal
                              ? () async {
                                  Navigator.pushNamed(
                                    context,
                                    ListyItemViewerScreen.routeName,
                                    arguments: e.title,
                                  );
                                }
                              : () =>
                                  addToOtherListy(e.title, path!, entityType!),
                          title: e.title,
                          iconPath: e.icon,
                          logoName: '',
                          // color: kMainIconColor,
                        ),
                        VSpace(),
                      ],
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
