// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/global/modals/video_options_modal.dart';
import 'package:explorer/global/widgets/advanced_video_player/widgets/custom_icon_button.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SafeArea(
          child: Column(
            children: [
              VSpace(),
              CustomIconButton(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => VideoOptionsModal(),
                  );
                },
                iconData: Icons.settings,
                color: Colors.white.withOpacity(.6),
              ),
            ],
          ),
        )
      ],
    );
  }
}
