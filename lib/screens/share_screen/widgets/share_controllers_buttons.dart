// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/host_note_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/ip_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:permission_handler/permission_handler.dart';

class ShareControllersButtons extends StatefulWidget {
  const ShareControllersButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareControllersButtons> createState() =>
      _ShareControllersButtonsState();
}

class _ShareControllersButtonsState extends State<ShareControllersButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Responsive.getWidth(context),
      child: PaddingWrapper(
        padding: EdgeInsets.symmetric(horizontal: kHPad * 2),
        child: Row(
          children: [
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad * 2,
                vertical: kVPad / 2,
              ),
              onTap: () async {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => HostNoteModal(),
                );
              },
              backgroundColor: Colors.white,
              child: Text(
                'host'.i18n(),
                style: h3TextStyle.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            ButtonWrapper(
              padding: EdgeInsets.symmetric(
                horizontal: kHPad * 2,
                vertical: kVPad / 2,
              ),
              onTap: handleJoinButton,
              backgroundColor: kBlueColor,
              child: Text(
                'join'.i18n(),
                style: h3TextStyle.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleJoinButton() async {
    try {
      var res = await getPossibleIpAddress();
      if (res == null || res.isEmpty) {
        logger.e('You are not connected to any network!');
        throw CustomException(
          e: 'You are not connected to any network!',
          s: StackTrace.current,
        );
      }
      //? open qr scanner camera and scan the qr code which has
      //? hotspot ssid:password:ip:port
      //? or if we are connected through wifi, i will use the
      //? ::ip:port
      //? this will tell the other device that we are using the same wifi network
      await Permission.camera.request();
      // this will return either a direct connLink or a encrypted qr code
      var qrCode = await Navigator.pushNamed(
        context,
        ScanQRCodeScreen.routeName,
      );

      handleConnectToHostWithCode(qrCode, context);
    } catch (e, s) {
      if (!mounted) return;
      showSnackBar(
        context: context,
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
      CustomException(e: e, s: s);
    }
  }
}

void handleConnectToHostWithCode(Object? qrCode, BuildContext context) async {
  if (qrCode is String) {
    if (qrCode.contains(' ') && int.tryParse(qrCode.split(' ').last) != null) {
      //? 1] i will get a working ip of the server
      //? 2] if there is working ip, then i will start /addClient (client_utils.addClient)
      //? 3] done
      String? workingLink = await client_utils.shareSpaceGetWorkingLink(
        qrCode,
        serverPF(context),
        sharePF(context),
        shareExpPF(context),
      );
      logger.i('Working Ip is $workingLink');
      if (workingLink == null) {
        await serverPF(context).closeServer();
        throw CustomException(
          e: 'You aren\'t connected on the same network',
          s: StackTrace.current,
        );
      }
      await client_utils.addClient(
        'http://$workingLink',
        sharePF(context),
        serverPF(context),
        shareExpPF(context),
      );
      //this mean that it has an encrypted text
    }
    //? here just open the link and start adding a client
  }
}
