// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_to_laptop_utils.dart';
import 'package:flutter/material.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/models/captures_entity_model.dart';
import 'package:explorer/utils/files_operations_utils/files_utils.dart';
import 'package:desktop_drop/desktop_drop.dart' as drop;
import 'package:explorer/utils/general_utils.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class SendFilesScreen extends StatefulWidget {
  static const String routeName = '/SendFilesScreen';
  const SendFilesScreen({super.key});

  @override
  State<SendFilesScreen> createState() => _SendFilesScreenState();
}

class _SendFilesScreenState extends State<SendFilesScreen> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    PeerModel peerModel =
        ModalRoute.of(context)!.settings.arguments as PeerModel;

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Send Files',
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          Expanded(
            child: Center(
              child:
                  //! after installing the drop package, just replace the SizedBox with the above line
                  //! then uncomment the handlers
                  drop.DropTarget(
                onDragDone: (details) {
                  var capturedFiles =
                      pathsToEntities(details.files.map((e) => e.path));
                  handleSendCapturesFiles(capturedFiles, peerModel);
                },
                onDragEntered: (details) {
                  setState(() {
                    active = true;
                  });
                },
                onDragExited: (details) {
                  setState(() {
                    active = false;
                  });
                },
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: 400,
                  ),
                  child: ButtonWrapper(
                    onTap: () async {
                      var res = await file_picker.FilePicker.platform
                          .pickFiles(allowMultiple: true);
                      if (res == null || res.files.isEmpty) return;
                      var capturedFiles =
                          pathsToEntities(res.files.map((e) => e.path));
                      handleSendCapturesFiles(capturedFiles, peerModel);
                    },
                    width: Responsive.getWidth(context) / 1.2,
                    height: Responsive.getWidth(context) / 1.2,
                    decoration: BoxDecoration(
                        color: kCardBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          mediumBorderRadius,
                        ),
                        border: Border.all(
                          width: 2,
                          color: kMainIconColor.withOpacity(active ? .5 : .1),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VSpace(),
                        Image.asset(
                          'assets/icons/folder_empty.png',
                          width: largeIconSize * 3,
                          color: kMainIconColor.withOpacity(active ? .5 : .1),
                        ),
                        VSpace(),
                        active
                            ? Text(
                                'Release to drop',
                                style: h3LightTextStyle,
                              )
                            : RichText(
                                text: TextSpan(
                                  text: 'Drop files here',
                                  style: h3InactiveTextStyle,
                                  children: [
                                    TextSpan(
                                      text: ' or',
                                      style: h3TextStyle,
                                    ),
                                    TextSpan(
                                      text: ' Browse',
                                      style: h3LiteTextStyle.copyWith(
                                        color: Colors.blue,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void handleSendCapturesFiles(
    List<CapturedEntityModel> entities,
    PeerModel peerModel,
  ) async {
    try {
      showSnackBar(context: context, message: 'Sending files');
      // Navigator.pop(context);
      await startSendEntities(
        entities,
        context,
        peerModel,
      );
    } on DioError catch (e) {
      String? refuseMessage = e.response?.data;
      showSnackBar(
        context: context,
        message: refuseMessage ?? 'Can\'t send',
        snackBarType: SnackBarType.error,
      );
    }
  }
}
