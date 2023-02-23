// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/share_space_v_screen_data.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_to_laptop_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/send_txt_to_phone_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:explorer/screens/share_space_viewer_screen/share_space_viewer_screen.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'dart:io';


class ConnectLaptopScreen extends StatelessWidget {
  static const String routeName = '/ConnectLaptopScreen';
  const ConnectLaptopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var connectLaptopProvider = connectLaptopP(context);
    if (connectLaptopProvider.remoteIP == null) {
      if (Navigator.canPop(context)) {
        Future.delayed(Duration.zero).then((value) {
          Navigator.pop(context);
        });
      }
    }

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Your Windows',
              style: h2TextStyle,
            ),
            leftIcon: IconButton(
              onPressed: () {
                connectLaptopPF(context).closeServer();
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
          if (kDebugMode && connectLaptopProvider.remoteIP != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    're   ${getConnLink(connectLaptopProvider.remoteIP!, connectLaptopProvider.remotePort!)}'),
                Text(
                    'my ${getConnLink(connectLaptopProvider.myIp!, connectLaptopProvider.myPort)}'),
              ],
            ),
          VSpace(),
          Expanded(
            child: PaddingWrapper(
              child: SingleChildScrollView(
                child: Column(children: [
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: ShareSpaceVScreenData(
                          peerModel: null,
                          laptop: true,
                          dataType: ShareSpaceVScreenDataType.filesExploring,
                        ),
                      );
                    },
                    title: 'Files Explorer',
                    logoName: 'folder_empty',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      var phoneConnProvider = connectLaptopPF(context);

                      Navigator.pushNamed(
                        context,
                        ShareSpaceVScreen.routeName,
                        arguments: ShareSpaceVScreenData(
                          peerModel: PeerModel(
                            deviceID: 'null',
                            joinedAt: DateTime.now(),
                            name: 'Phone',
                            memberType: MemberType.client,
                            ip: phoneConnProvider.remoteIP!,
                            port: phoneConnProvider.remotePort!,
                            sessionID: 'null',
                          ),
                          laptop: true,
                          dataType: ShareSpaceVScreenDataType.shareSpace,
                        ),
                      );
                    },
                    title: 'Share Space',
                    logoName: 'management',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      String? clipboard =
                          await getPhoneClipboard(connectLaptopPF(context));
                      if (clipboard == null) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => ModalWrapper(
                            showTopLine: false,
                            color: kCardBackgroundColor,
                            child: Text(
                              'Make sure the app is open on phone (not in background)\nThis is due to Android security',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => DoubleButtonsModal(
                            onOk: () {
                              copyToClipboard(context, clipboard);
                            },
                            title: 'Phone Clipboard',
                            subTitle: clipboard,
                            showCancelButton: false,
                            okColor: kBlueColor,
                            okText: 'Copy',
                          ),
                        );
                      }
                    },
                    title: 'Copy Clipboard',
                    logoName: 'paste',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => SendTextToPhoneModal(),
                      );
                    },
                    title: 'Send Text',
                    logoName: 'txt',
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      var res = await file_picker.FilePicker.platform
                          .pickFiles(allowMultiple: false);
                      if (res != null && res.files.isNotEmpty) {
                        String? path = res.files.first.path;
                        if (path == null) return;
                        int fileSize = File(path).lengthSync();
                        await startDownloadFile(path, fileSize, context);
                        logger.i('sending file $path to phone');
                        showSnackBar(
                            context: context, message: 'Sending file to phone');
                      }
                    },
                    title: 'Send File',
                    logoName: 'link',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  // AnalyzerOptionsItem(
                  //   enablePadding: false,
                  //   onTap: () {},
                  //   title: 'Windows Listy',
                  //   logoName: 'list1',
                  // ),
                  // VSpace(),
                  // AnalyzerOptionsItem(
                  //   enablePadding: false,
                  //   onTap: () {},
                  //   title: 'Recently Opened',
                  //   logoName: 'clock',
                  //   color: kMainIconColor,
                  // ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
