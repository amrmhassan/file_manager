// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrResultModal extends StatelessWidget {
  final String? code;
  const QrResultModal({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
        color: kBackgroundColor,
        showTopLine: false,
        child: Column(
          children: [
            Text('scan-result'.i18n(), style: h3InactiveTextStyle),
            VSpace(),
            SelectableText(
              code.toString(),
              style: h4TextStyle.copyWith(overflow: TextOverflow.visible),
            ),
            VSpace(),
            Row(
              children: [
                if (code?.startsWith('http://') ?? false)
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ButtonWrapper(
                            backgroundColor: kBlueColor,
                            padding: EdgeInsets.symmetric(vertical: kVPad / 2),
                            onTap: () {
                              launchUrlString(
                                code!,
                                mode: LaunchMode.externalApplication,
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              'open-website'.i18n(),
                              style: h4TextStyle,
                            ),
                          ),
                        ),
                        HSpace(),
                      ],
                    ),
                  ),
                Expanded(
                  child: ButtonWrapper(
                    backgroundColor: kBlueColor,
                    padding: EdgeInsets.symmetric(vertical: kVPad / 2),
                    onTap: () {
                      copyToClipboard(context, code ?? '');
                      Navigator.pop(context);
                    },
                    child: Text(
                      'copy'.i18n(),
                      style: h4TextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
