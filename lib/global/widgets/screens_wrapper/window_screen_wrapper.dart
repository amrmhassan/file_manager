// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/custom_app_drawer/custom_app_drawer.dart';
import 'package:explorer/global/widgets/go_back_button_windows.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/laptop_messages_button.dart';
import 'package:explorer/global/widgets/quick_send_open_button.dart';
import 'package:explorer/global/widgets/screens_wrapper/windows_app_bar.dart';
import 'package:explorer/global/widgets/video_player_viewer/widgets/video_player_show_button.dart';
import 'package:explorer/windows_app_code/global/widgets/media_controllers_windows.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

import '../../../windows_app_code/global/widgets/advanced_video_player/advanced_video_player.dart';
import '../../../windows_app_code/global/widgets/show_controllers_buttons_windows.dart';

class WindowsScreensWrapper extends StatefulWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;

  //? drop your scaffold props here
  const WindowsScreensWrapper({
    Key? key,
    required this.child,
    this.floatingActionButton,
    this.backgroundColor,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  State<WindowsScreensWrapper> createState() => _WindowsScreensWrapperState();
}

class _WindowsScreensWrapperState extends State<WindowsScreensWrapper> {
  GlobalKey<ScaffoldState> scfKey = GlobalKey();
  GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);

    return Scaffold(
      key: scfKey,
      backgroundColor: widget.backgroundColor,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: false,
      drawer: CustomAppDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              WindowsAppBar(buttonKey: buttonKey, scfKey: scfKey),
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  // onTap: () {
                  //   FocusScope.of(context).requestFocus(FocusNode());
                  // },
                  child: SafeArea(
                    top: !(mpProvider.videoPlayerController != null &&
                        (!mpProvider.videoHidden)),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: widget.child,
                                    ),
                                  ),
                                  MediaControllersWindows(),
                                ],
                              ),
                              Positioned(
                                bottom: -1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ShowControllersButtonWindows(),
                                    HSpace(),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: -1,
                                child: Row(
                                  children: [
                                    HSpace(),
                                    VideoPlayerShowButton(),
                                  ],
                                ),
                              ),
                              // VideoPlayerViewer(),
                              if (mpProvider.videoPlayerController != null &&
                                  (!mpProvider.videoHidden))
                                AdvancedVideoPlayerWindows(),

                              QuickSendOpnButton(),
                              MessagesButton(),
                            ],
                          ),
                        ),
                        GoBackWindows(),

                        // if (Platform.isWindows &&
                        //     (ModalRoute.of(context)
                        //                 ?.settings
                        //                 .name
                        //                 ?.toString() ??
                        //             '') !=
                        //         HomeScreen.routeName)
                        //   Container(
                        //     width: double.infinity,
                        //     height: largeIconSize * 1.5,
                        //     color: kCardBackgroundColor,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         CustomIconButton(
                        //           onTap: () {
                        //             Navigator.pop(context);
                        //           },
                        //           iconData: Icons.arrow_forward_ios,
                        //         ),
                        //         HSpace(factor: 2),
                        //       ],
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
