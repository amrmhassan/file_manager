// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/models/tab_model.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleTab extends StatelessWidget {
  final TabModel tabModel;

  const SingleTab({
    Key? key,
    required this.tabModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    bool active = expProvider.activeTabPath == tabModel.path;
    return ButtonWrapper(
      onTap: () {
        Provider.of<ExplorerProvider>(context, listen: false).openTab(
            tabModel.path,
            Provider.of<FilesOperationsProvider>(context, listen: false));
      },
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: active ? kBackgroundColor : null,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(mediumBorderRadius),
            bottomRight: Radius.circular(mediumBorderRadius),
          )),
      child: Row(
        children: [
          HSpace(factor: .5),
          SizedBox(
            width: kHPad * 2,
            child: Flexible(
              fit: FlexFit.tight,
              child: Text(
                tabModel.title,
                style: h5InactiveTextStyle.copyWith(
                  height: 1.4,
                  fontWeight: active ? FontWeight.bold : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          HSpace(factor: .5),
          ButtonWrapper(
            borderRadius: 500,
            padding: EdgeInsets.all(largePadding),
            onTap: () {
              Provider.of<ExplorerProvider>(context, listen: false).closeTab(
                tabModel.path,
                Provider.of<FilesOperationsProvider>(
                  context,
                  listen: false,
                ),
              );
            },
            child: Image.asset(
              'assets/icons/close.png',
              width: ultraSmallIconSize / 1.4,
              color: kMainIconColor.withOpacity(.7),
            ),
          )
        ],
      ),
    );
  }
}
