// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/path_row.dart';
import 'package:explorer/screens/explorer_screen/widgets/select_all_button.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPathViewer extends StatefulWidget {
  final bool sizesExplorer;
  final String? customPath;
  final VoidCallback? onHomeClicked;
  final VoidCallback? onCopy;
  final Function(String subPath)? onClickingSubPath;

  const CurrentPathViewer({
    Key? key,
    required this.sizesExplorer,
    this.customPath,
    this.onHomeClicked,
    this.onCopy,
    this.onClickingSubPath,
  }) : super(key: key);

  @override
  State<CurrentPathViewer> createState() => _CurrentPathViewerState();
}

class _CurrentPathViewerState extends State<CurrentPathViewer> {
  final ScrollController _scrollController = ScrollController();

  _scrollToRight() {
    try {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    } catch (e) {
      printOnDebug(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToRight());
    } catch (e) {
      printOnDebug(e);
    }

    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var pathPartHeight = largePadding * 2 + ultraLargeIconSize / 2;
    return Row(
      children: [
        ButtonWrapper(
          onTap: widget.onHomeClicked ??
              () {
                var foProviderFalse = Provider.of<FilesOperationsProvider>(
                  context,
                  listen: false,
                );
                expProviderFalse.goHome(
                  sizesExplorer: widget.sizesExplorer,
                  analyzerProvider:
                      Provider.of<AnalyzerProvider>(context, listen: false),
                  filesOperationsProvider: foProviderFalse,
                );
              },
          borderRadius: 0,
          padding: EdgeInsets.all(largePadding),
          child: Image.asset(
            'assets/icons/home.png',
            color: kMainIconColor,
            width: ultraLargeIconSize / 2,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: widget.onCopy ??
                () => copyToClipboard(
                    context, expProviderFalse.currentActiveDir.path),
            child: Container(
              width: double.infinity,
              color: kCardBackgroundColor,
              height: pathPartHeight,
              // alignment: Alignment.center,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    HSpace(),
                    PathRow(
                      sizesExplorer: widget.sizesExplorer,
                      customPath: widget.customPath,
                      onCopy: widget.onCopy,
                      onClickingSubPath: widget.onClickingSubPath,
                    ),
                    HSpace(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (foProvider.exploreMode == ExploreMode.selection) SelectAllButton(),
      ],
    );
  }
}
