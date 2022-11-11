// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/path_row.dart';
import 'package:explorer/screens/home_screen/widgets/path_entity_text.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPathViewer extends StatefulWidget {
  final bool sizesExplorer;
  const CurrentPathViewer({
    Key? key,
    required this.sizesExplorer,
  }) : super(key: key);

  @override
  State<CurrentPathViewer> createState() => _CurrentPathViewerState();
}

class _CurrentPathViewerState extends State<CurrentPathViewer> {
  final ScrollController _scrollController = ScrollController();

  _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  void didUpdateWidget(covariant CurrentPathViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToRight());

    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    var foProvider =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    var pathPartHeight = largePadding * 2 + ultraLargeIconSize / 2;
    return Row(
      children: [
        ButtonWrapper(
          onTap: () => expProviderFalse.goHome(
              sizesExplorer: widget.sizesExplorer,
              analyzerProvider:
                  Provider.of<AnalyzerProvider>(context, listen: false)),
          borderRadius: 0,
          padding: EdgeInsets.all(largePadding),
          child: Image.asset(
            'assets/icons/home.png',
            color: Colors.white,
            width: ultraLargeIconSize / 2,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => copyPathToClipboard(
                context, expProviderFalse.currentActiveDir.path),
            child: Container(
              width: double.infinity,
              color: kCardBackgroundColor,
              height: pathPartHeight,
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  children: [
                    HSpace(),
                    PathRow(
                      sizesExplorer: widget.sizesExplorer,
                    ),
                    HSpace(),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (foProvider.explorMode == ExplorMode.selection)
          ButtonWrapper(
            onTap: () {
              var currentDirChildren =
                  Provider.of<ExplorerProvider>(context, listen: false)
                      .children;
              Provider.of<FilesOperationsProvider>(context, listen: false)
                  .selectAll(currentDirChildren);
              showSnackBar(
                  context: context,
                  message: 'Here i will allow selected and deselect all');
            },
            borderRadius: 0,
            padding: EdgeInsets.all(largePadding),
            child: Image.asset(
              'assets/icons/select-all.png',
              color: Colors.white,
              width: ultraLargeIconSize / 2,
            ),
          ),
      ],
    );
  }
}
