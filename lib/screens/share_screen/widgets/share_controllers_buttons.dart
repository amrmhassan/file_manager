// ignore_for_file: prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class ShareControllersButtons extends StatelessWidget {
  const ShareControllersButtons({
    Key? key,
  }) : super(key: key);

  @Deprecated('This will be removed in next updata')
  void test() {}

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
                ConnectivityResult connRes =
                    await Connectivity().checkConnectivity();
                if (connRes == ConnectivityResult.wifi) {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => DoubleButtonsModal(
                      onOk: () async {
                        //? here open the hotspot then show the connection parameters as qr code
                        //? wifi ssid:password:ip:port
                      },
                      okText: 'HotSpot',
                      okColor: kBlueColor,
                      onCancel: () {
                        //? here just open the server on the currently connected wifi
                      },
                      cancelText: 'WiFi',
                      title: 'You are connected to WiFi network',
                      subTitle:
                          'Use connected wifi or open HotSpot for sharing ?',
                    ),
                  );
                }
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
                //? open qr scanner camera and scan the qr code which has
                //? hotspot ssid:password:ip:port
                //? or if we are connected through wifi, i will use the
                //? ::ip:port
                //? this will tell the other device that we are using the same wifi network
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
