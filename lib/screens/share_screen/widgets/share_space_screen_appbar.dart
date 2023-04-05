// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/group_info_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class ShareSpaceScreenAppBar extends StatelessWidget {
  const ShareSpaceScreenAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);

    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    return CustomAppBar(
      title: Text(
        serverProvider.myIp == null
            ? 'your-share-space'.i18n()
            : 'group-share-space'.i18n(),
        style: h2TextStyle.copyWith(
          color: kActiveTextColor,
        ),
      ),
      rightIcon: serverProvider.myIp == null ||
              serverProvider.myType == MemberType.client
          ? null
          : Row(
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
            ),
      leftIcon: serverProvider.myIp != null
          ? Row(
              children: [
                SizedBox(width: kHPad / 2),
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  // onLongPress: () {
                  //   var shareItemsExplorerProvider =
                  //       Provider.of<ShareItemsExplorerProvider>(context,
                  //           listen: false);

                  //   Provider.of<ServerProvider>(context, listen: false)
                  //       .restartServer(
                  //           shareProviderFalse, shareItemsExplorerProvider);
                  // },
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => GroupInfoModal(
                        serverProvider: serverProvider,
                        onLeaveGroup: () {
                          client_utils.unsubscribeMe(serverProviderFalse);
                          // the client server will be closed from the custom client socket
                          // and this will happen if the host is disconnected
                          // or when i am disconnected
                          // so i don't need to call the close server form here
                          if (serverProviderFalse.myType == MemberType.host) {
                            serverProviderFalse.closeServer();
                          }
                        },
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
    );
  }
}
