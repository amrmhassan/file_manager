// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/whats_app_files_screen/whats_app_files_screen.dart';
import 'package:explorer/screens/whats_app_screen/widgets/status_item.dart';
import 'package:explorer/screens/whats_app_screen/widgets/whats_app_folder_card.dart';
import 'package:explorer/screens/whats_app_screen/widgets/whatsapp_section_title.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

enum MediaType {
  image,
  video,
  audio,
  voiceNote,
  documents,
  statusImages,
  statusVideo,
}

class WhatsAppScreen extends StatelessWidget {
  static const String routeName = '/WhatsAppScreen';
  const WhatsAppScreen({super.key});

  void openFilesScreen(MediaType mediaType, BuildContext context) {
    Navigator.pushNamed(
      context,
      WhatsappFilesScreen.routeName,
      arguments: mediaType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'whatsapp-media'.i18n(),
              style: h2TextStyle,
            ),
          ),
          VSpace(),
          PaddingWrapper(
            child: WhatsAppSectionTitle(
              title: 'messages'.i18n(),
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
                    title: 'images-text'.i18n(),
                    onTap: () {
                      openFilesScreen(MediaType.image, context);
                    },
                  ),
                  WhatsAppFolderCard(
                    iconName: 'video',
                    title: 'videos-text'.i18n(),
                    onTap: () {
                      openFilesScreen(MediaType.video, context);
                    },
                  ),
                  WhatsAppFolderCard(
                    iconName: 'audio',
                    title: 'music-text'.i18n(),
                    onTap: () {
                      openFilesScreen(MediaType.audio, context);
                    },
                  ),
                  WhatsAppFolderCard(
                    iconName: 'voice-note',
                    title: 'voice-notes'.i18n(),
                    onTap: () {
                      openFilesScreen(MediaType.voiceNote, context);
                    },
                  ),
                  WhatsAppFolderCard(
                    iconName: 'documents',
                    title: 'docs-text'.i18n(),
                    onTap: () {
                      openFilesScreen(MediaType.documents, context);
                    },
                  ),
                ],
              ),
            ),
          ),
          VSpace(),
          HLine(
            thickness: 1,
            widthFactor: .9,
            color: kCardBackgroundColor,
          ),
          VSpace(factor: .5),
          PaddingWrapper(
            child: Column(
              children: [
                WhatsAppSectionTitle(
                  title: 'statuses'.i18n(),
                ),
                VSpace(),
                Row(
                  children: [
                    StatusItem(
                      iconName: 'photo',
                      onTap: () {
                        openFilesScreen(MediaType.statusImages, context);
                      },
                      title: 'images-text'.i18n(),
                    ),
                    HSpace(),
                    StatusItem(
                      iconName: 'video',
                      onTap: () {
                        openFilesScreen(MediaType.statusVideo, context);
                      },
                      title: 'videos-text'.i18n(),
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
