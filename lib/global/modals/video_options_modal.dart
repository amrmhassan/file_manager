import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';

class VideoOptionsModal extends StatelessWidget {
  const VideoOptionsModal({
    super.key,
  });

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
              value: '0.25x',
              title: 'Speed',
              onTap: () {},
              showBottomLine: false,
            )
          ],
        ));
  }
}
