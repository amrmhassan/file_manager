// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/providers/dir_children_list_provider.dart';
import 'package:explorer/screens/home_screen/widgets/path_entity_text.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentPathViewer extends StatefulWidget {
  const CurrentPathViewer({
    Key? key,
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
    var pathPartHeight = largePadding * 2 + ultraLargeIconSize / 2;
    return Row(
      children: [
        ButtonWrapper(
          onTap: expProviderFalse.goHome,
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
                    PathRow(),
                    HSpace(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PathRow extends StatelessWidget {
  const PathRow({super.key});

  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    List<String> folders = expProvider.currentActiveDir.path.split('/');

    return GestureDetector(
      onLongPress: () =>
          copyPathToClipboard(context, expProviderFalse.currentActiveDir.path),
      child: Row(
        children: [
          ...folders.asMap().entries.map(
            (entry) {
              return Row(
                children: [
                  PathEntityText(
                    pathEntity: entry.value,
                    onTap: () {
                      if (entry.key != folders.length - 1) {
                        String newPath =
                            folders.sublist(0, entry.key + 1).join('/');
                        expProviderFalse.setActiveDir(newPath);
                      } else {
                        copyPathToClipboard(
                            context, expProviderFalse.currentActiveDir.path);
                      }
                    },
                  ),
                  if (entry.key != folders.length - 1)
                    Image.asset(
                      'assets/icons/right-arrow.png',
                      width: smallIconSize,
                      color: kInactiveColor,
                    )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
