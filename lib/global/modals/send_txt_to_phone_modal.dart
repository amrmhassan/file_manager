// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:localization/localization.dart';

class SendTextToPhoneModal extends StatefulWidget {
  const SendTextToPhoneModal({
    super.key,
  });

  @override
  State<SendTextToPhoneModal> createState() => _SendTextToPhoneModalState();
}

class _SendTextToPhoneModalState extends State<SendTextToPhoneModal> {
  TextEditingController data = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DoubleButtonsModal(
      autoPop: true,
      onOk: () async {
        try {
          String connLink =
              connectLaptopPF(context).getPhoneConnLink(EndPoints.sendText);

          await Dio().post(connLink,
              data: data.text,
              options: Options(
                requestEncoder: (request, options) => utf8.encode(request),
              ));
          showSnackBar(context: context, message: 'message-sent'.i18n());
        } catch (e) {
          showSnackBar(
            context: context,
            message: e.toString(),
            snackBarType: SnackBarType.error,
          );
        }
      },
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
