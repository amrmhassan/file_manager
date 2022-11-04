// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentPathViewer extends StatefulWidget {
  final Directory currentActiveDir;
  final VoidCallback goHome;
  final Function(String path) clickFolder;
  const CurrentPathViewer({
    Key? key,
    required this.currentActiveDir,
    required this.goHome,
    required this.clickFolder,
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
    if (oldWidget.currentActiveDir.path != widget.currentActiveDir.path) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToRight());
    }
    super.didUpdateWidget(oldWidget);
  }

  void copyPathToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.currentActiveDir.path));
    showSnackBar(context: context, message: 'Copied To Clipboard');
  }

  Widget getPathRow(String path) {
    List<String> folders = path.split('/');
    printOnDebug(folders);
    return GestureDetector(
      onLongPress: () {
        copyPathToClipboard();
      },
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
                        widget.clickFolder(newPath);
                      } else {
                        copyPathToClipboard();
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

  @override
  Widget build(BuildContext context) {
    var pathPartHeight = largePadding * 2 + ultraLargeIconSize / 2;
    return Row(
      children: [
        ButtonWrapper(
          onTap: widget.goHome,
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
            onTap: copyPathToClipboard,
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
                    getPathRow(widget.currentActiveDir.path),
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

class PathEntityText extends StatelessWidget {
  final String pathEntity;
  final VoidCallback onTap;
  const PathEntityText({
    Key? key,
    required this.pathEntity,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        pathEntity,
        style: h4TextStyleInactive,
        maxLines: 1,
      ),
    );
  }
}
