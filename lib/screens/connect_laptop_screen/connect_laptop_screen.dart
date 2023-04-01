// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/models/captures_entity_model.dart';
import 'package:explorer/screens/full_text_screen/full_text_screen.dart';
import 'package:explorer/screens/touchpad_screen/touchpad_screen.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_to_laptop_utils.dart';
import 'package:explorer/utils/files_operations_utils/files_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/send_txt_to_phone_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/analyzer_screen/widgets/analyzer_options_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:explorer/utils/server_utils/connection_utils.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:localization/localization.dart';

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
              connectLaptopProvider.laptopName ?? 'your-windows'.i18n(),
              style: h2TextStyle,
            ),
            // rightIcon: connectLaptopProvider.laptopMessages.isEmpty
            //     ? null
            //     : Row(
            //         children: [
            //           IconButton(
            //               onPressed: () {
            //                 Navigator.pushNamed(
            //                   context,
            //                   LaptopMessagesScreen.routeName,
            //                 );
            //               },
            //               icon: Icon(
            //                 Icons.message,
            //                 color: kMainIconColor,
            //               )),
            //           HSpace(factor: .3),
            //         ],
            //       ),
            leftIcon: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => DoubleButtonsModal(
                    autoPop: true,
                    onOk: () {
                      connectLaptopPF(context).closeServer();
                    },
                    okText: 'close'.i18n(),
                    title: 'close-connection'.i18n(),
                    subTitle: 'close-connection-note'.i18n(),
                  ),
                );
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
                      // Navigator.pushNamed(
                      //   context,
                      //   ShareSpaceVScreen.routeName,
                      //   arguments: ShareSpaceVScreenData(
                      //     peerModel: null,
                      //     laptop: true,
                      //     dataType: ShareSpaceVScreenDataType.filesExploring,
                      //   ),
                      // );
                    },
                    title: 'files-explorer'.i18n(),
                    logoName: 'folder_empty',
                    color: kMainIconColor,
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      // var phoneConnProvider = connectLaptopPF(context);

                      // Navigator.pushNamed(
                      //   context,
                      //   ShareSpaceVScreen.routeName,
                      //   arguments: ShareSpaceVScreenData(
                      //     peerModel: PeerModel(
                      //       deviceID: laptopID,
                      //       name: laptopName,
                      //       memberType: MemberType.client,
                      //       ip: phoneConnProvider.remoteIP!,
                      //       port: phoneConnProvider.remotePort!,
                      //       sessionID: laptopID,
                      //       deviceType: DeviceType.windows,
                      //     ),
                      //     laptop: true,
                      //     dataType: ShareSpaceVScreenDataType.shareSpace,
                      //   ),
                      // );
                    },
                    title: 'share-space-intro'.i18n(),
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
                              'empty-clipboard-note'.i18n(),
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
                              Navigator.pop(context);
                            },
                            title: 'windows-clipboard'.i18n(),
                            subTitle: clipboard,
                            showCancelButton: true,
                            cancelText: 'expand'.i18n(),
                            autoPop: false,
                            onCancel: () {
                              Navigator.pushReplacementNamed(
                                context,
                                FullTextViewerScreen.routeName,
                                arguments: clipboard,
                              );
                            },
                            okColor: kBlueColor,
                            okText: 'copy'.i18n(),
                          ),
                        );
                      }
                    },
                    title: 'copy-clipboard'.i18n(),
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
                    title: 'send-text'.i18n(),
                    logoName: 'txt',
                  ),
                  VSpace(),
                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () async {
                      var res = await file_picker.FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (res == null || res.files.isEmpty) return;
                      var capturedFiles =
                          pathsToEntities(res.files.map((e) => e.path));
                      handleSendCapturesFiles(capturedFiles, context);
                      showSnackBar(
                          context: context,
                          message: 'sending-file-to-laptop'.i18n());
                    },
                    title: 'send-file'.i18n(),
                    logoName: 'link',
                    color: kMainIconColor,
                  ),
                  VSpace(),

                  AnalyzerOptionsItem(
                    enablePadding: false,
                    onTap: () {
                      Navigator.pushNamed(context, TouchPadScreen.routeName);
                    },
                    title: 'widows-touchpad'.i18n(),
                    logoName: 'touchpad',
                    color: kMainIconColor,
                  ),
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

  void handleSendCapturesFiles(
    List<CapturedEntityModel> entities,
    BuildContext context,
  ) async {
    // showSnackBar(context: context, message: 'sending-to-phone'.i18n());
    // Navigator.pop(context);
    // await startSendEntities(entities, context, );
  }
}
