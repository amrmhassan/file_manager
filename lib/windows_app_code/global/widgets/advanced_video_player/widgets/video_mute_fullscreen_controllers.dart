// ignore_for_file: prefer_const_constructors

import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './custom_icon_button.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';

class VideoMuteFullScreenControllers extends StatelessWidget {
  final VoidCallback toggleLandscape;

  const VideoMuteFullScreenControllers({
    super.key,
    required this.toggleLandscape,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);
    var mpProviderFalse = WindowSProviders.mpPF(context);
    var winProvider = WindowSProviders.winP(context);

    return FadeInRight(
      preferences: AnimationPreferences(
        duration: Duration(milliseconds: 350),
      ),
      child: PaddingWrapper(
        child: Row(
          children: [
            Spacer(),
            CustomIconButton(
              color: Colors.white.withOpacity(.8),
              onTap: () {
                mpProviderFalse.toggleMuteVideo();
              },
              iconData: mpProvider.videoMuted
                  ? FontAwesomeIcons.volumeXmark
                  : FontAwesomeIcons.volumeLow,
            ),
            CustomIconButton(
              onTap: toggleLandscape,
              iconData: winProvider.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
            ),
          ],
        ),
      ),
    );
  }
}
