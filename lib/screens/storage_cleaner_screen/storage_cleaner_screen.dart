// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/screens/home_screen/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorageCleanerScreen extends StatefulWidget {
  static const String routeName = '/StorageCleanerScreen';
  const StorageCleanerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StorageCleanerScreen> createState() => _StorageCleanerScreenState();
}

class _StorageCleanerScreenState extends State<StorageCleanerScreen> {
  @override
  Widget build(BuildContext context) {
    var analyzerProvider = Provider.of<AnalyzerProvider>(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          HomeAppBar(
            activeScreenIndex: 0,
            setActiveScreen: (a) {},
            sizesExplorer: true,
            title: 'Storage Cleaner',
          ),
          HLine(
            width: 1,
            color: kCardBackgroundColor,
          ),
          analyzerProvider.loading
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: kInverseColor,
                          strokeWidth: 2,
                        ),
                        VSpace(),
                        Text(
                          'Loading',
                          style: h4TextStyleInactive,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VSpace(),
                    AnalyzerOptionsItem(
                      logoName: 'big-file',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ItemsViewerScreen.routeName,
                          arguments: ItemsType.bigFiles,
                        );
                      },
                      title: 'Big Files',
                      color: kInverseColor,
                    ),
                    VSpace(factor: .5),
                    AnalyzerOptionsItem(
                      logoName: 'clock',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ItemsViewerScreen.routeName,
                          arguments: ItemsType.oldFiles,
                        );
                      },
                      title: 'Old Files',
                      color: kInverseColor,
                    ),
                    VSpace(factor: .5),
                    AnalyzerOptionsItem(
                      logoName: 'clock',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ItemsViewerScreen.routeName,
                          arguments: ItemsType.modifiedFiles,
                        );
                      },
                      title: 'Modified Files',
                      color: kInverseColor,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
