// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrentPathViewer extends StatelessWidget {
  CurrentPathViewer({
    Key? key,
    required this.currentActiveDir,
  }) : super(key: key);

  final Directory currentActiveDir;
  final ScrollController _scrollController = ScrollController();
  _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: currentActiveDir.path));
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
                currentActiveDir.path,
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
