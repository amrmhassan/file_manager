// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/ask_for_share_space_modal.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/home_screen/widgets/custom_check_box.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  static const String routeName = '/testing-screen';
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () async {
              showAskForShareSpaceModal('userName', context);
            },
            child: Text('Ask'),
          )
        ],
      ),
    );
  }
}
