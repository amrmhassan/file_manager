// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animation_preferences.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/styles.dart';
import '../../../../utils/windows_provider_calls.dart';
import './close_video_button.dart';
import './settings_button.dart';
import './video_lower_background_shader.dart';

class VideoUpperControllers extends StatelessWidget {
  const VideoUpperControllers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);
    return Stack(
      children: [
        VideoLowerBackgroundShader(
          reverse: true,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CloseVideoButton(),
            // Text(
            //   'data',
            //   style: h4LightTextStyle.copyWith(height: 1),
            // ),
            Expanded(
              child: SafeArea(
                child: Text(
                  getFileName(mpProvider.playingVideoPath ?? ''),
                  style: h4TextStyle.copyWith(height: 5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            FadeInRight(
              preferences: AnimationPreferences(
                duration: Duration(milliseconds: 350),
              ),
              child: SettingsButton(),
            ),
          ],
        ),
      ],
    );
  }
}
