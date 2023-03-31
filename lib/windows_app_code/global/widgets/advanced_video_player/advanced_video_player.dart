// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import './widgets/base_over_lay.dart';
import './widgets/controllers_overlay.dart';
import '/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import 'widgets/actual_video_player.dart';

class AdvancedVideoPlayer extends StatefulWidget {
  final bool isOverlay;
  final OverlayEntry? overlayEntry;

  const AdvancedVideoPlayer({
    Key? key,
    this.isOverlay = false,
    this.overlayEntry,
  }) : super(key: key);

  @override
  State<AdvancedVideoPlayer> createState() => _AdvancedVideoPlayerState();
}

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer>
    with WidgetsBindingObserver {
  OverlayEntry? overlayEntry;
  bool controllerOverLayViewed = true;
  var previousPressedKey;
  FocusNode focusNode = FocusNode();
  // fast seek backward
  bool backwardShown = false;
  int backwardAmount = 0;
  int backwardActualAmount = 0;
  // fast seek forward
  bool forwardShown = false;
  int forwardAmount = 0;
  int forwardActualAmount = 0;

//? to toggle between them
  void toggleLandScape() async {
    await WindowSProviders.winPF(context).toggleFullScreen();
    if (WindowSProviders.winPF(context).isFullScreen) {
      //? here i want to show an overlay for viewing the video
      overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
          body: AdvancedVideoPlayer(
            isOverlay: true,
            overlayEntry: overlayEntry,
          ),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Overlay.of(context).insert(overlayEntry!);
      });
    } else {
      widget.overlayEntry?.remove();
      //? i here i want to hide the overlay for vieweing the video
    }
  }

//?
  void setControllersOverlayViewed(bool v) {
    setState(() {
      controllerOverLayViewed = v;
    });
  }

//?
  void toggleControllerOverLayViewed() async {
    setState(() {
      controllerOverLayViewed = !controllerOverLayViewed;
    });
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    var mediaProvider =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    if (mediaProvider.videoPlayerController == null) return;
  }

  @override
  void dispose() {
    Wakelock.disable();
    WindowSProviders.winPF(navigatorKey.currentContext!)
        .setFullScreen(false, false);
    overlayEntry?.remove();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var winProvider = WindowSProviders.winP(context);
    return winProvider.isFullScreen && !widget.isOverlay
        ? SizedBox()
        : Focus(
            autofocus: true,
            focusNode: focusNode,
            onKey: okKeyboardPressed,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ActualVideoPlayer(),
                BaseOverLay(
                  toggleControllerOverLayViewed: toggleControllerOverLayViewed,
                  backwardActualAmount: backwardActualAmount,
                  backwardShown: backwardShown,
                  forwardActualAmount: forwardActualAmount,
                  forwardShown: forwardShown,
                ),
                if (controllerOverLayViewed)
                  ControllersOverlay(
                    toggleControllerOverLayViewed:
                        toggleControllerOverLayViewed,
                    toggleLandscape: toggleLandScape,
                  ),
              ],
            ),
          );
  }

  void handleForward() {
    if (!WindowSProviders.mpPF(context).isVideoPlaying) return;
    WindowSProviders.mpPF(context).videoForWard10();
    setState(() {
      forwardAmount += 10;
      forwardActualAmount += 10;
      forwardShown = true;
    });

    Future.delayed(Duration(milliseconds: 600)).then((value) {
      forwardAmount -= 10;

      if (!mounted) return;
      if (forwardAmount == 0) {
        setState(() {
          forwardActualAmount = 0;
          forwardShown = false;
        });
      }
    });
  }

  void handleBackward() {
    if (!WindowSProviders.mpPF(context).isVideoPlaying) return;

    WindowSProviders.mpPF(context).videoBackWard10();
    setState(() {
      backwardAmount += 10;
      backwardActualAmount += 10;
      backwardShown = true;
    });

    Future.delayed(Duration(milliseconds: 600)).then((value) {
      backwardAmount -= 10;

      if (!mounted) return;
      if (backwardAmount == 0) {
        setState(() {
          backwardActualAmount = 0;
          backwardShown = false;
        });
      }
    });
  }

  KeyEventResult okKeyboardPressed(FocusNode node, RawKeyEvent event) {
    var mpProviderFalse = WindowSProviders.mpPF(context);

    if (event.data.physicalKey.debugName == previousPressedKey ||
        event.repeat) {
      previousPressedKey = null;
      return KeyEventResult.ignored;
    }
    var pressedKey = event.data.physicalKey;
    //? here handle pressing keys
    if (pressedKey == PhysicalKeyboardKey.keyM) {
      mpProviderFalse.toggleMuteVideo();
    } else if (pressedKey == PhysicalKeyboardKey.keyF) {
      toggleLandScape();
    } else if (pressedKey == PhysicalKeyboardKey.arrowRight) {
      handleForward();
    } else if (pressedKey == PhysicalKeyboardKey.arrowLeft) {
      handleBackward();
    } else if (pressedKey == PhysicalKeyboardKey.arrowUp) {
      logger.i('raising voice');
    } else if (pressedKey == PhysicalKeyboardKey.arrowDown) {
      logger.i('decreasing voice');
    } else if (pressedKey == PhysicalKeyboardKey.space) {
      mpProviderFalse.toggleVideoPlay();
      try {
        if (mpProviderFalse.isVideoPlaying) {
          WindowSProviders.animationPF(context).pausePlayAnimation?.reverse();
        } else {
          WindowSProviders.animationPF(context).pausePlayAnimation?.forward();
        }
      } catch (e) {
        //
      }
    } else if (pressedKey == PhysicalKeyboardKey.keyH) {
      logger.i('hiding video');
    }
    previousPressedKey = event.data.physicalKey.debugName;
    return KeyEventResult.handled;
  }
}
