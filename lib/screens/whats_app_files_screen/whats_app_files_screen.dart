// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:flutter/material.dart';

class WhatsappFilesScreen extends StatefulWidget {
  static const String routeName = '/WhatsappFilesScreen';
  const WhatsappFilesScreen({super.key});

  @override
  State<WhatsappFilesScreen> createState() => _WhatsappFilesScreenState();
}

class _WhatsappFilesScreenState extends State<WhatsappFilesScreen> {
  String get title {
    MediaType mediaType =
        ModalRoute.of(context)!.settings.arguments as MediaType;
    if (mediaType == MediaType.image) {
      return 'Images';
    } else if (mediaType == MediaType.video) {
      return 'Videos';
    } else if (mediaType == MediaType.audio) {
      return 'Audios';
    } else if (mediaType == MediaType.voiceNote) {
      return 'Voice Notes';
    } else if (mediaType == MediaType.statusImages) {
      return 'Images Statuses';
    } else if (mediaType == MediaType.statusVideo) {
      return 'Videos Statuses';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              'WhatsApp $title',
              style: h2TextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
