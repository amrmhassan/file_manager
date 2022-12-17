// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/listy_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/listy_items_viewer_screen/listy_items_viewer_screen.dart';
import 'package:explorer/screens/listy_screen/listy_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListyItem extends StatelessWidget {
  final ListyModel e;
  final String? path;
  final EntityType? entityType;
  final OpenMode openMode;

  const ListyItem({
    super.key,
    required this.e,
    required this.entityType,
    required this.path,
    required this.openMode,
  });

  Future removeAListy(String listyTitle, BuildContext context) async {
    Provider.of<ListyProvider>(context, listen: false).removeListy(listyTitle);
  }

  //? add item to custom listy other than favorite
  Future addToOtherListy(
      String listyTitle, String p, EntityType e, BuildContext context) async {
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
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(e.title),
      direction: e.title == defaultListyList.first.title
          ? DismissDirection.none
          : DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool returnValue = false;
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (ctx) => DoubleButtonsModal(
            onOk: () async {
              returnValue = true;
              await removeAListy(e.title, context);
            },
            okText: 'Remove',
            title: 'Remove This list?',
          ),
        );
        return returnValue;
      },
      child: Column(
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
                : () => addToOtherListy(e.title, path!, entityType!, context),
            title: e.title,
            iconPath: e.icon,
            logoName: '',
            color:
                e.title == defaultListyList.first.title ? null : kMainIconColor,
            // color: kMainIconColor,
          ),
          VSpace(factor: .5),
          if (e.title == defaultListyList.first.title)
            HLine(
              color: kCardBackgroundColor,
              thickness: 1,
            ),
          VSpace(factor: .5),
        ],
      ),
    );
  }
}
