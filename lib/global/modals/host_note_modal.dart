// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/constants/widget_keys.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class HostNoteModal extends StatelessWidget {
  const HostNoteModal({
    super.key,
  });
  Future<bool> localOpenServerHandler(BuildContext context) async {
    await serverPF(context).openServer(
      sharePF(context),
      MemberType.host,
      shareExpPF(context),
    );
    return serverPF(navigatorKey.currentContext!).httpServer != null;
  }

  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      autoPop: true,
      onOk: () async {
        try {
          bool res = await localOpenServerHandler(context);
          if (res) {
            await Navigator.pushNamed(
              navigatorKey.currentContext!,
              QrCodeViewerScreen.routeName,
            );
          }
        } catch (e, s) {
          showSnackBar(
            context: navigatorKey.currentContext!,
            message: CustomException(
              e: e,
              s: s,
            ).toString(),
            snackBarType: SnackBarType.error,
          );
        }
      },
      showCancelButton: false,
      title: '',
      okColor: kBlueColor,
      okText: 'continue'.i18n(),
      subTitle: 'host-note'.i18n(),
      titleIcon: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/warning.png',
                width: mediumIconSize,
              ),
              HSpace(),
              Text(
                'note'.i18n(),
                style: h3TextStyle,
              )
            ],
          ),
          VSpace(),
        ],
      ),
    );
  }
}
