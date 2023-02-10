// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
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
      rightIcon: serverProvider.myType == MemberType.host
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
                    //       client_utils.unsubscribeMe(serverProviderFalse);
                    //       // the client server will be closed from the custom client socket
                    //       // and this will happen if the host is disconnected
                    //       // or when i am disconnected
                    //       // so i don't need to call the close server form here
                    //       if (serverProviderFalse.myType == MemberType.host) {
                    //         serverProviderFalse.closeServer();
                    //       }
                    //     },
                    //     okText: 'Close',
                    //     cancelText: 'Cancel',
                    //     title: 'Close server?',
                    //   ),
                    // );
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

class GroupInfoModal extends StatelessWidget {
  const GroupInfoModal({
    super.key,
    required this.serverProvider,
    required this.onLeaveGroup,
  });

  final ServerProvider serverProvider;
  final VoidCallback onLeaveGroup;

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
    return ModalWrapper(
        bottomPaddingFactor: .8,
        color: kBackgroundColor,
        showTopLine: false,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Your Name',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    shareProvider.myName,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Your session ID',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    serverProvider.me(shareProvider).sessionID,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Your Device ID',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    shareProvider.myDeviceId,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Your Device ID',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    shareProvider.myDeviceId,
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Connected Devices',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    (serverProvider.peers.length - 1).toString(),
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Member Type',
                  style: h4TextStyle,
                ),
                HSpace(factor: .2),
                Expanded(
                  child: Text(
                    capitalizeWord(serverProvider.myType.name),
                    style: h5LiteTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            VSpace(),
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad,
                vertical: kVPad / 2,
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    onOk: () {
                      onLeaveGroup();
                    },
                    okText: serverProvider.myType == MemberType.host
                        ? 'Close'
                        : 'Leave',
                    title: 'Are you sure?',
                    subTitle:
                        'closing the group will cut any downloads or streams',
                  ),
                );
              },
              backgroundColor: kDangerColor,
              child: Text(
                serverProvider.myType == MemberType.host
                    ? 'Close Group'
                    : 'Leave Group',
                style: h4TextStyle,
              ),
            ),
          ],
        ));
  }
}
