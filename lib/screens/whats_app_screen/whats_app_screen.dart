// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/whats_app_screen/widgets/status_item.dart';
import 'package:explorer/screens/whats_app_screen/widgets/whats_app_folder_card.dart';
import 'package:explorer/screens/whats_app_screen/widgets/whatsapp_section_title.dart';
import 'package:flutter/material.dart';

class WhatsAppScreen extends StatelessWidget {
  static const String routeName = '/WhatsAppScreen';
  const WhatsAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'WhatsApp Media',
              style: h2TextStyle.copyWith(color: Colors.white),
            ),
          ),
          VSpace(),
          PaddingWrapper(
            child: WhatsAppSectionTitle(
              title: 'Messages',
            ),
          ),
          VSpace(),
          Expanded(
            child: PaddingWrapper(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: kHPad,
                crossAxisSpacing: kVPad,
                children: [
                  // ...List.generate(10, (index) => WhatsAppFolderCard()),
                  WhatsAppFolderCard(
                    iconName: 'photo',
                    title: 'Images',
                    onTap: () {},
                  ),
                  WhatsAppFolderCard(
                    iconName: 'video',
                    title: 'Videos',
                    onTap: () {},
                  ),
                  WhatsAppFolderCard(
                    iconName: 'audio',
                    title: 'Audios',
                    onTap: () {},
                  ),
                  WhatsAppFolderCard(
                    iconName: 'voice-note',
                    title: 'Voice Notes',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          VSpace(),
          HLine(
            thickness: 1,
            widthFactor: .9,
            color: Colors.white.withOpacity(.2),
          ),
          VSpace(factor: .5),
          PaddingWrapper(
            child: Column(
              children: [
                WhatsAppSectionTitle(
                  title: 'Statuses',
                ),
                VSpace(),
                Row(
                  children: [
                    StatusItem(
                      iconName: 'photo',
                      onTap: () {},
                      title: 'Images',
                    ),
                    HSpace(),
                    StatusItem(
                      iconName: 'video',
                      onTap: () {},
                      title: 'Videos',
                    ),
                  ],
                ),
              ],
            ),
          ),
          VSpace(),
        ],
      ),
    );
  }
}
