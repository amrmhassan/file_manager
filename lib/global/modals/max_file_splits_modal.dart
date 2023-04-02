// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class MaxFileSplitsModal extends StatelessWidget {
  const MaxFileSplitsModal({
    super.key,
    required this.downloadProvider,
  });

  final DownloadProvider downloadProvider;

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      bottomPaddingFactor: .1,
      afterLinePaddingFactor: .5,
      showTopLine: false,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: kHPad),
      color: kCardBackgroundColor,
      child: Expanded(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: List.generate(
              10,
              (index) => ListTile(
                    leading: Opacity(
                      opacity: (index + 1) ==
                              downloadProvider.maximumDownloadSplitsForAFile
                          ? 1
                          : 0,
                      child: Image.asset(
                        'assets/icons/check.png',
                        color: kMainIconColor,
                        width: smallIconSize,
                      ),
                    ),
                    onTap: () {
                      downPF(context)
                          .setMaximumDownloadSplitsForAFile(index + 1);
                      Navigator.pop(context);
                    },
                    title: Text(
                      (index + 1).toString(),
                      style: h3LightTextStyle,
                    ),
                  )),
        ),
      ),
    );
  }
}
