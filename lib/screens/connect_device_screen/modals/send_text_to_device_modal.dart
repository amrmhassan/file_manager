// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/permission_result_model.dart';
import 'package:explorer/utils/client_utils.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:localization/localization.dart';

class SendTextToDeviceModal extends StatefulWidget {
  final PeerModel peerModel;

  const SendTextToDeviceModal({
    super.key,
    required this.peerModel,
  });

  @override
  State<SendTextToDeviceModal> createState() => _SendTextToDeviceModalState();
}

class _SendTextToDeviceModalState extends State<SendTextToDeviceModal> {
  TextEditingController data = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      onOk: () async {
        Navigator.pop(context);
        PermissionResultModel? result = await showWaitPermissionModal(
          () => sendTextToDevice(data.text, widget.peerModel),
        );
        if (result == null) {
          return;
        }

        if (result.error != null) return;
        fastSnackBar(msg: 'message-sent'.i18n());
      },
      autoPop: false,
      showCancelButton: false,
      extra: Column(
        children: [
          CustomTextField(
            controller: data,
            title: 'enter-text-to-send'.i18n(),
            padding: EdgeInsets.zero,
            autoFocus: true,
            textInputType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 3,
            textStyle: h4LightTextStyle,
          ),
          VSpace(factor: .6),
        ],
      ),
      okColor: kBlueColor,
      okText: 'send'.i18n(),
    );
  }
}
