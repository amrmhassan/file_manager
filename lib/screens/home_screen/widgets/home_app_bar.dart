// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/app_bar_icon_button.dart';
import 'package:explorer/screens/home_screen/widgets/explorer_mode_switcher.dart';
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            if (activeScreenIndex == 1)
              AppBarIconButton(
                  onTap: () =>
                      Provider.of<ExplorerProvider>(context, listen: false)
                          .goBack(
                              sizesExplorer: sizesExplorer,
                              analyzerProvider: Provider.of<AnalyzerProvider>(
                                  context,
                                  listen: false)),
                  iconName: 'back'),
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
                      //? Add a new folder after showing a modal
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (ctx) {
                            return ModalWrapper(
                              afterLinePaddingFactor: 0,
                              bottomPaddingFactor: 0,
                              padding: EdgeInsets.zero,
                              color: kCardBackgroundColor,
                              showTopLine: false,
                              borderRadius: mediumBorderRadius,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ButtonWrapper(
                                    borderRadius: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kHPad / 2,
                                      vertical: kVPad / 2,
                                    ),
                                    onTap: () {},
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Create Folder',
                                      style: h4TextStyleInactive.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  ButtonWrapper(
                                    borderRadius: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kHPad / 2,
                                      vertical: kVPad / 2,
                                    ),
                                    onTap: () {},
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Create Folder',
                                      style: h4TextStyleInactive.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
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
        if (!sizesExplorer)
          ExplorerModeSwitcher(
            activeScreenIndex: activeScreenIndex,
            setActiveScreen: setActiveScreen,
          ),
      ],
    );
  }
}
