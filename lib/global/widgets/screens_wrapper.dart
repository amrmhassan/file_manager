// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/video_player_viewer.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/media_controllers.dart';
import 'package:explorer/global/widgets/show_controllers_button.dart';
import 'package:flutter/material.dart';

class ScreensWrapper extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final Widget? drawer;
  final GlobalKey<ScaffoldState>? scfKey;

  //? drop your scaffold props here
  const ScreensWrapper({
    Key? key,
    required this.child,
    this.floatingActionButton,
    this.backgroundColor,
    this.floatingActionButtonLocation,
    this.drawer,
    this.scfKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scfKey,
      drawer: drawer,
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: false,
      //! i make gesture detector to be inkwell to accept clicks even if the area is blank
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: child,
                    ),
                  ),
                  MediaControllers(),
                ],
              ),
              Positioned(
                bottom: -1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShowControllersButton(),
                    HSpace(),
                  ],
                ),
              ),
              VideoPlayerViewer()
            ],
          ),
        ),
      ),
    );
  }
}
