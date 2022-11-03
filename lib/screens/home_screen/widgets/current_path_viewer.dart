// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentPathViewer extends StatefulWidget {
  final Directory currentActiveDir;
  const CurrentPathViewer({
    Key? key,
    required this.currentActiveDir,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: widget.currentActiveDir.path));
        showSnackBar(context: context, message: 'Copied To Clipboard');
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: kVPad / 2),
        color: kCardBackgroundColor,
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              HSpace(),
              Text(
                widget.currentActiveDir.path,
                style: h4TextStyleInactive,
                maxLines: 1,
              ),
              HSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
