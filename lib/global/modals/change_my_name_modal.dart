// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class ChangeMyNameModal extends StatefulWidget {
  const ChangeMyNameModal({
    super.key,
  });

  @override
  State<ChangeMyNameModal> createState() => _ChangeMyNameModalState();
}

class _ChangeMyNameModalState extends State<ChangeMyNameModal> {
  TextEditingController nameController = TextEditingController();
  late String name;
  @override
  void initState() {
    nameController.text = sharePF(context).myName;
    name = nameController.text;
    nameController.selection =
        TextSelection(baseOffset: 0, extentOffset: nameController.text.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
        bottomPaddingFactor: 1,
        padding: EdgeInsets.zero,
        color: kCardBackgroundColor,
        showTopLine: false,
        borderRadius: mediumBorderRadius,
        child: Column(
          children: [
            CustomTextField(
              title: 'your-name'.i18n(),
              autoFocus: true,
              controller: nameController,
              maxLength: 10,
              onChange: (v) {
                setState(() {
                  name = v;
                });
              },
              buildCounter: (
                p0, {
                required currentLength,
                required isFocused,
                maxLength,
              }) =>
                  SizedBox(),
            ),
            VSpace(),
            PaddingWrapper(
              child: ButtonWrapper(
                active: name.length > 2,
                onTap: () async {
                  await sharePF(context).updateMyName(nameController.text);
                  Navigator.pop(context);
                },
                padding: EdgeInsets.symmetric(
                  horizontal: kHPad,
                  vertical: kVPad / 2,
                ),
                borderRadius: smallBorderRadius,
                backgroundColor: kBackgroundColor,
                child: Text('save'.i18n()),
              ),
            ),
          ],
        ));
  }
}
