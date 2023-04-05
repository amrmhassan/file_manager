// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/modals/video_speed_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class VideoOptionsModal extends StatelessWidget {
  const VideoOptionsModal({
    super.key,
  });

  double videoSpeed(BuildContext context) {
    if (Platform.isAndroid) {
      return mpPF(context).videoSpeed;
    } else {
      return WindowSProviders.mpPF(context).videoSpeed;
    }
  }

  bool networkVideo(BuildContext context) {
    if (Platform.isAndroid) {
      return mpPF(context).networkVideo;
    } else {
      return WindowSProviders.mpPF(context).networkVideo;
    }
  }

  @override
  Widget build(BuildContext context) {
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
              value: videoSpeed(context) == 1
                  ? 'normal'.i18n()
                  : '${videoSpeed(context).toStringAsFixed(2)}x',
              title: 'speed'.i18n(),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => VideoSpeedsModal(),
                );
              },
              showBottomLine: true,
            ),
            if (networkVideo(context))
              ModalButtonElement(
                title: 'Copy stream link'.i18n(),
                onTap: () {
                  Navigator.pop(context);
                  if (Platform.isAndroid) {
                    copyToClipboard(context, mpPF(context).networkStreamLink!);
                  } else {
                    copyToClipboard(context,
                        WindowSProviders.mpPF(context).networkStreamLink!);
                  }
                },
                showBottomLine: false,
              ),
          ],
        ));
  }
}
