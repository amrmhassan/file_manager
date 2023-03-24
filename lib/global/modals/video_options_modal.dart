// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/modals/video_speed_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class VideoOptionsModal extends StatelessWidget {
  const VideoOptionsModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = mpP(context);
    return ModalWrapper(
        clip: Clip.hardEdge,
        showTopLine: false,
        color: kCardBackgroundColor,
        afterLinePaddingFactor: .4,
        padding: EdgeInsets.zero,
        bottomPaddingFactor: .3,
        child: Column(
          children: [
            ModalButtonElement(
              value: mpProvider.videoSpeed == 1
                  ? 'normal'.i18n()
                  : '${mpProvider.videoSpeed.toStringAsFixed(2)}x',
              title: 'speed'.i18n(),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => VideoSpeedsModal(),
                );
              },
              showBottomLine: false,
            ),
          ],
        ));
  }
}
