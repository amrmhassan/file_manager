// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class VideoSpeedsModal extends StatelessWidget {
  const VideoSpeedsModal({
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
        children: List.generate(8, (index) => (index + 1) * .25)
            .map((e) => ListTile(
                  onTap: () {
                    mpPF(context).setVideoSpeed(e);
                    Navigator.pop(context);
                  },
                  leading: Opacity(
                    opacity: mpP(context).videoSpeed == e ? 1 : 0,
                    child: Image.asset(
                      'assets/icons/check.png',
                      color: kMainIconColor,
                      width: smallIconSize,
                    ),
                  ),
                  title: Text(
                    e == 1 ? 'Normal' : '${e.toStringAsFixed(2)}x',
                    style: h4TextStyle,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
