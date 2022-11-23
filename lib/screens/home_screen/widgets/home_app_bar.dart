// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
import 'package:explorer/screens/home_screen/widgets/selected_item_number.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  final int activeScreenIndex;
  final Function(int index) setActiveScreen;
  final bool sizesExplorer;

  const HomeAppBar({
    super.key,
    required this.activeScreenIndex,
    required this.setActiveScreen,
    required this.sizesExplorer,
  });

  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);
    var expProvider = Provider.of<ExplorerProvider>(context);
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            if (activeScreenIndex == 1)
              AppBarIconButton(
                onTap: () {
                  // var foProviderFalse = Provider.of<FilesOperationsProvider>(
                  //   context,
                  //   listen: false,
                  // );
                  // Provider.of<ExplorerProvider>(context, listen: false).goBack(
                  //   sizesExplorer: sizesExplorer,
                  //   analyzerProvider:
                  //       Provider.of<AnalyzerProvider>(context, listen: false),
                  //   filesOperationsProvider: foProviderFalse,
                  // );
                  Scaffold.of(context).openDrawer();
                },
                iconName: 'list',
              ),
            //! this will hold the progress of the loading operation if i figure a way to do so
            if (foProvider.loadingOperation)
              SizedBox(
                width: smallIconSize,
                height: smallIconSize,
                child: CircularProgressIndicator(
                  color: kBlueColor,
                  strokeWidth: 2,
                ),
              )
            else if (foProvider.selectedItems.isNotEmpty)
              SelectedItemNumber(foProvider: foProvider),
            Spacer(),
            Spacer(),
            if (expProvider.loadingChildren ||
                analyzerProvider.savingInfoToSqlite)
              SizedBox(
                width: smallIconSize,
                height: smallIconSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            activeScreenIndex == 1
                ? AppBarIconButton(
                    onTap: () {
                      showCurrentActiveDirOptions(context);
                    },
                    iconName: 'dots',
                    color: Colors.white,
                  )
                : AppBarIconButton(
                    onTap: () {
                      showSnackBar(context: context, message: 'Rescanning');
                      Provider.of<AnalyzerProvider>(context, listen: false)
                          .clearAllData();
                      Provider.of<AnalyzerProvider>(context, listen: false)
                          .handleAnalyzeEvent();
                    },
                    iconName: 'reload',
                  ),
          ],
        ),
        !sizesExplorer
            ? ExplorerModeSwitcher(
                activeScreenIndex: activeScreenIndex,
                setActiveScreen: setActiveScreen,
              )
            : Text(
                'Sizes Explorer',
                style: h2TextStyle.copyWith(color: Colors.white),
              ),
      ],
    );
  }
}
