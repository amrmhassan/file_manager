// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
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
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeViewerScreen extends StatelessWidget {
  static const String routeName = '/QrCodeViewerScreen';
  const QrCodeViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var serverProvider = Provider.of<ServerProvider>(context);
    String? quickSendLink =
        ModalRoute.of(context)?.settings.arguments as String?;

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
            leftIcon: Row(
              children: [
                SizedBox(width: kHPad / 2),
                ButtonWrapper(
                  padding: EdgeInsets.all(largePadding),
                  borderRadius: 0,
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => ModalWrapper(
                        color: kCardBackgroundColor,
                        showTopLine: false,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '1- Host Device Can connect over wifi or hotspot',
                            ),
                            Text(
                              '2- Joining Devices must connect over wifi',
                            ),
                            Text(
                              '3- Open hotspot from one device, it will be host',
                            ),
                            Text(
                              '4- Connect others to the hotspot then scan QR',
                            ),
                          ],
                        ),
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
                    if (quickSendLink != null) {
                      Navigator.pop(context);
                      copyToClipboard(context, serverProvider.myConnLink!);
                    }
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
                            data: quickSendLink ?? serverProvider.myConnLink!,
                          ),
                        ),
                        if (quickSendLink != null)
                          SelectableText(
                            quickSendLink,
                            style: h3InactiveTextStyle,
                          ),
                        VSpace(),
                        if (quickSendLink != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonWrapper(
                                padding: EdgeInsets.symmetric(
                                  horizontal: kHPad,
                                  vertical: kVPad / 2,
                                ),
                                onTap: () async {
                                  await quickSPF(context).closeSend();
                                  Navigator.pop(context);
                                },
                                backgroundColor: kDangerColor,
                                child: Text(
                                  'Close Send',
                                  style: h4TextStyle,
                                ),
                              ),
                            ],
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
                        '1- Connect the devices to the same network',
                        style: h4TextStyleInactive,
                      ),
                      Text(
                        '2- Network can be router(wifi) or one of the devices hotspot',
                        style: h4TextStyleInactive,
                      ),
                      Text(
                        '3- Others click join then scan QR code',
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
