// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/full_text_screen/full_text_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class LaptopMessagesScreen extends StatefulWidget {
  static const String routeName = '/LaptopMessagesScreen';
  const LaptopMessagesScreen({super.key});

  @override
  State<LaptopMessagesScreen> createState() => _LaptopMessagesScreenState();
}

class _LaptopMessagesScreenState extends State<LaptopMessagesScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) {
        connectLaptopPF(context).markAllMessagesAsViewed();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    connectLaptopPF(context).markAllMessagesAsViewed(false);

    var connLapProvider = connectLaptopP(context);
    if (connLapProvider.laptopMessages.isEmpty) {
      Future.delayed(Duration.zero).then((value) {
        Navigator.pop(context);
      });
    }
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'Laptop Messages',
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          Expanded(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              var message = connLapProvider.laptopMessages[index];

              return Dismissible(
                onDismissed: (direction) {
                  connectLaptopPF(context).removeLaptopMessage(message.id);
                },
                key: UniqueKey(),
                child: ButtonWrapper(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      FullTextViewerScreen.routeName,
                      arguments: message.msg,
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 100),
                    color: kCardBackgroundColor,
                    margin: EdgeInsets.only(bottom: smallPadding),
                    padding: EdgeInsets.symmetric(
                      horizontal: kHPad,
                      vertical: kVPad / 2,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            message.msg,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                        CopyButton(text: message.msg),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: connLapProvider.laptopMessages.length,
          ))
        ],
      ),
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ButtonWrapper(
          padding: EdgeInsets.all(largePadding),
          onTap: () {
            copyToClipboard(context, text);
          },
          child: Image.asset(
            'assets/icons/paste.png',
            color: kMainIconColor,
            width: smallIconSize,
          ),
        ),
      ],
    );
  }
}
