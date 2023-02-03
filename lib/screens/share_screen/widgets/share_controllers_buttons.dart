// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/screens/qr_code_viewer_screen/qr_code_viewer_screen.dart';
import 'package:explorer/screens/scan_qr_code_screen/scan_qr_code_screen.dart';
import 'package:explorer/utils/errors_collection/custom_exception.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
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
  Future localOpenServerHandler([bool wifi = true]) async {
    await serverPF(context).openServer(
      sharePF(context),
      shareExpPF(context),
      wifi,
    );
  }

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
                // ConnectivityResult connRes =
                //     await Connectivity().checkConnectivity();
                //! allow me [start]
                // await openServer();
                // Navigator.pushNamed(context, QrCodeViewerScreen.routeName);
                //! allow me [end]
                // if (connRes == ConnectivityResult.wifi) {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    onOk: () async {
                      //! i can't open hotspot yet
                      //! so i will suppose that user has already opened it and connected the other device to him
                      //? here open the hotspot then show the connection parameters as qr code
                      //? wifi ssid:password:ip:port
                      try {
                        await localOpenServerHandler(false);
                        Navigator.pushNamed(
                            context, QrCodeViewerScreen.routeName);
                      } catch (e, s) {
                        showSnackBar(
                          context: context,
                          message: throw CustomException(
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
                      //? here just open the server on the currently connected wifi
                      try {
                        await localOpenServerHandler(true);
                        Navigator.pushNamed(
                            context, QrCodeViewerScreen.routeName);
                      } catch (e, s) {
                        showSnackBar(
                          context: context,
                          message: throw CustomException(
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
                // }
              },
              backgroundColor: Colors.white,
              child: Text(
                'Host',
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
              onTap: () async {
                try {
                  //? open qr scanner camera and scan the qr code which has
                  //? hotspot ssid:password:ip:port
                  //? or if we are connected through wifi, i will use the
                  //? ::ip:port
                  //? this will tell the other device that we are using the same wifi network
                  await Permission.camera.request();
                  var qrCode = await Navigator.pushNamed(
                    context,
                    ScanQRCodeScreen.routeName,
                  );
                  if (qrCode is String) {
                    //? here just open the link and start adding a client

                    await client_utils.addClient(
                      qrCode,
                      sharePF(context),
                      serverPF(context),
                      shareExpPF(context),
                      context,
                    );
                  }
                } catch (e, s) {
                  throw CustomException(e: e, s: s);
                  showSnackBar(context: context, message: e.toString());
                }
              },
              backgroundColor: kBlueColor,
              child: Text(
                'Join',
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
}
