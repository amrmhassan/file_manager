// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/share_button.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

void quickSendHandler(BuildContext context) async {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) => DoubleButtonsModal(
      autoPop: false,
      onOk: () async {
        try {
          Navigator.pop(context);
          await quickSPF(context)
              .quickShareFile(foPF(context).selectedItems.first.path, false);
          foPF(context).clearAllSelectedItems(expPF(context));
          Navigator.pushNamed(context, QrCodeViewerScreen.routeName,
              arguments: quickSPF(context).fileConnLink);
        } catch (e, s) {
          showSnackBar(
            context: context,
            message: CustomException(
              e: e,
              s: s,
            ).toString(),
            snackBarType: SnackBarType.error,
          );
        }
      },
      okText: 'HotSpot',
      okColor: kBlueColor,
      onCancel: () async {
        try {
          Navigator.pop(context);

          await quickSPF(context)
              .quickShareFile(foPF(context).selectedItems.first.path, true);
          foPF(context).clearAllSelectedItems(expPF(context));
          Navigator.pushNamed(context, QrCodeViewerScreen.routeName,
              arguments: quickSPF(context).fileConnLink);
        } catch (e, s) {
          showSnackBar(
            context: context,
            message: CustomException(
              e: e,
              s: s,
            ).toString(),
            snackBarType: SnackBarType.error,
          );
        }
      },
      cancelText: 'WiFi',
      // title: 'You are connected to WiFi network',
      title: 'Choose a network to connect through',
      // subTitle:
      //     'Use connected wifi or open HotSpot for sharing ?',
    ),
  );
}

class ShareViewModal extends StatelessWidget {
  const ShareViewModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
        color: kBackgroundColor,
        showTopLine: false,
        child: PaddingWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share Via', style: h3TextStyle),
              VSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShareOptionButton(
                    iconName: 'other',
                    title: 'Others',
                    onTap: () {
                      Navigator.pop(context);
                      shareFileHandler(context);
                    },
                  ),
                  HSpace(factor: 1.7),
                  ShareOptionButton(
                    iconName: 'logo',
                    title: 'Quick',
                    onTap: () {
                      Navigator.pop(context);
                      quickSendHandler(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class ShareOptionButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String iconName;

  const ShareOptionButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: onTap,
      padding: EdgeInsets.all(largePadding),
      child: Column(
        children: [
          Image.asset(
            'assets/icons/$iconName.png',
            width: largeIconSize * 1.6,
          ),
          VSpace(factor: .5),
          Text(
            title,
            style: h4TextStyleInactive,
          ),
        ],
      ),
    );
  }
}
