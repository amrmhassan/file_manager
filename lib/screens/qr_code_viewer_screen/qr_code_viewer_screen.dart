// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/server_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeViewerScreen extends StatelessWidget {
  static const String routeName = '/QrCodeViewerScreen';
  const QrCodeViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'No Data Needed',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
            rightIcon: Row(
              children: [
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  onTap: () {
                    // showModalBottomSheet(
                    //   backgroundColor: Colors.transparent,
                    //   context: context,
                    //   builder: (context) => ModalWrapper(
                    //     color: kCardBackgroundColor,
                    //     showTopLine: false,
                    //     child: Text(
                    //       'Connections guides will be here',
                    //     ),
                    //   ),
                    // );
                    Navigator.pop(context);
                  },
                  // Image.asset(
                  //   'assets/icons/info.png',
                  //   width: mediumIconSize,
                  //   color: Colors.white,
                  // )
                  child: Icon(
                    Icons.arrow_forward,
                    color: kMainIconColor,
                    size: mediumIconSize,
                  ),
                ),
                SizedBox(width: kHPad / 2),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You can go back after scanning'),
                VSpace(),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    copyToClipboard(context, serverProvider.myConnLink!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: kHPad),
                    child: Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: 250,
                            maxHeight: 250,
                            minHeight: 100,
                            minWidth: 100,
                          ),
                          child: QrImage(
                            backgroundColor: Colors.white,
                            data: '${serverProvider.myConnLink!}$dummyEndPoint',
                          ),
                        ),
                        SelectableText(
                          serverProvider.myConnLink!,
                          style: h3InactiveTextStyle,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          PaddingWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: double.infinity),
                Text('Guides:'),
                PaddingWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serverProvider.hostWithWifi
                            ? '1- Connect with others on the same wifi'
                            : '1- Open your hotspot',
                        style: h4TextStyleInactive,
                      ),
                      if (!serverProvider.hostWithWifi)
                        Text(
                          '2- Let other device connect to your HotSpot',
                          style: h4TextStyleInactive,
                        ),
                      Text(
                        '${serverProvider.hostWithWifi ? '2' : '3'}- Others click join then scan QR',
                        style: h4TextStyleInactive,
                      ),
                      VSpace(),
                    ],
                  ),
                ),
                // Text('Web Share:'),
                // PaddingWrapper(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         '1- Copy the above link or scan the Qr Code',
                //         style: h4TextStyleInactive,
                //       ),
                //       Text(
                //         '2- Paste it into the other device browser',
                //         style: h4TextStyleInactive,
                //       ),
                //       Text(
                //         '3- Let the magic happen',
                //         style: h4TextStyleInactive,
                //       ),
                //       VSpace(),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
