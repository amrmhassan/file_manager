// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/share_screen/widgets/empty_share_items.dart';
import 'package:explorer/screens/share_screen/widgets/shading_background.dart';
import 'package:explorer/screens/share_screen/widgets/share_screen_navbar.dart';
import 'package:explorer/screens/share_screen/widgets/shared_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareScreen extends StatelessWidget {
  static const String routeName = '/ShareScreen';
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var shareProvider = Provider.of<ShareProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(
            title: Text(
              'Share Space',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            rightIcon: shareProvider.httpServer != null
                ? Row(
                    children: [
                      ButtonWrapper(
                        padding: EdgeInsets.all(largePadding),
                        borderRadius: 0,
                        onTap: () {
                          showQrCodeModal(context);
                        },
                        child: Image.asset(
                          'assets/icons/qr-code.png',
                          width: mediumIconSize,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: kHPad / 2),
                    ],
                  )
                : null,
            leftIcon: shareProvider.httpServer != null
                ? Row(
                    children: [
                      SizedBox(width: kHPad / 2),
                      ButtonWrapper(
                        padding: EdgeInsets.all(largePadding),
                        borderRadius: 0,
                        onTap: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => DoubleButtonsModal(
                              onOk: () {
                                Provider.of<ShareProvider>(context,
                                        listen: false)
                                    .closeServer();
                              },
                              okText: 'Close',
                              cancelText: 'Cancel',
                              title: 'Close server?',
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/info.png',
                          width: mediumIconSize,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          VSpace(),
          Expanded(
            child: Stack(
              children: [
                if (shareProvider.sharedItems.isNotEmpty)
                  SharedItems()
                else
                  EmptyShareItems(),
                if (shareProvider.httpServer == null) ShadingBackground(),
              ],
            ),
          ),
          ShareScreenNavBar(),
        ],
      ),
    );
  }
}
