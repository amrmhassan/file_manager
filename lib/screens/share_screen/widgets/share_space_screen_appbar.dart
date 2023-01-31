// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareSpaceScreenAppBar extends StatelessWidget {
  const ShareSpaceScreenAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);

    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);

    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    return CustomAppBar(
      title: Text(
        serverProvider.httpServer == null
            ? 'Your Share Space'
            : 'Group Share Space',
        style: h2TextStyle.copyWith(
          color: kActiveTextColor,
        ),
      ),
      rightIcon: serverProvider.httpServer != null
          ? Row(
              children: [
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      QrCodeViewerScreen.routeName,
                    );
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
      leftIcon: serverProvider.httpServer != null
          ? Row(
              children: [
                SizedBox(width: kHPad / 2),
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  onLongPress: () {
                    var shareItemsExplorerProvider =
                        Provider.of<ShareItemsExplorerProvider>(context,
                            listen: false);

                    Provider.of<ServerProvider>(context, listen: false)
                        .restartServer(
                            shareProviderFalse, shareItemsExplorerProvider);
                  },
                  onTap: () {
                    // showModalBottomSheet(
                    //   backgroundColor: Colors.transparent,
                    //   context: context,
                    //   builder: (context) => DoubleButtonsModal(
                    //     onOk: () {
                    //       serverProviderFalse.closeServer();
                    //     },
                    //     okText: 'Close',
                    //     cancelText: 'Cancel',
                    //     title: 'Close server?',
                    //   ),
                    // );
                    //! this is just temporary
                    serverProviderFalse.closeServer();
                    client_utils.unsubscribeClient(
                      serverProviderFalse,
                      shareProviderFalse,
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
    );
  }
}
