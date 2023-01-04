// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/screens/whats_app_screen/whats_app_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class WhatsappFilesScreen extends StatefulWidget {
  static const String routeName = '/WhatsappFilesScreen';
  const WhatsappFilesScreen({super.key});

  @override
  State<WhatsappFilesScreen> createState() => _WhatsappFilesScreenState();
}

class _WhatsappFilesScreenState extends State<WhatsappFilesScreen> {
  List<StorageItemModel> children = [];
  StreamSubscription? streamSubscription;
  //? to get the folder path
  String? get path {
    String? whatsAppPath = getWhatsAppDir()?.path;
    if (whatsAppPath == null) {
      return null;
    }
    MediaType mediaType =
        ModalRoute.of(context)!.settings.arguments as MediaType;
    String folderPath = '';
    if (mediaType == MediaType.image) {
      folderPath = 'WhatsApp Images';
    } else if (mediaType == MediaType.video) {
      folderPath = 'WhatsApp Video';
    } else if (mediaType == MediaType.audio) {
      folderPath = 'WhatsApp Audio';
    } else if (mediaType == MediaType.voiceNote) {
      folderPath = 'WhatsApp Voice Notes';
    } else if (mediaType == MediaType.statusImages ||
        mediaType == MediaType.statusVideo) {
      folderPath = '.Statuses';
    } else if (mediaType == MediaType.documents) {
      folderPath = 'WhatsApp Documents';
    } else {
      return null;
    }
    return whatsAppPath + folderPath;
  }

//? to get the app bar title
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
    } else if (mediaType == MediaType.documents) {
      return 'Documents';
    } else {
      return '';
    }
  }

//? to fetch the files list
  void fetchFilesList() {
    String? folderPath = path;
    MediaType mediaType =
        ModalRoute.of(context)!.settings.arguments as MediaType;
    if (path == null) return;
    Directory directory = Directory(folderPath!);

    Stream<FileSystemEntity> stream =
        directory.list(recursive: mediaType == MediaType.voiceNote);
    streamSubscription = stream.listen((event) {
      String fileName = path_operations.basename(event.path);
      if (fileName.startsWith('.')) return;
      if (mediaType == MediaType.statusImages) {
        String ext = getFileExtension(event.path);
        FileType fileType = getFileType(ext);
        if (fileType == FileType.image) {
          addFileToChildren(event);
        }
      } else if (mediaType == MediaType.statusVideo) {
        String ext = getFileExtension(event.path);
        FileType fileType = getFileType(ext);
        if (fileType == FileType.video) {
          addFileToChildren(event);
        }
      } else {
        addFileToChildren(event);
      }
    });
  }

//? to convert file system entity to storage item model and add it to the children list
  void addFileToChildren(FileSystemEntity fileSystemEntity) {
    FileStat fileStat = fileSystemEntity.statSync();
    if (fileStat.type == FileSystemEntityType.file) {
      StorageItemModel storageItemModel = StorageItemModel(
        parentPath: fileSystemEntity.parent.path,
        path: fileSystemEntity.path,
        modified: fileStat.modified,
        accessed: fileStat.accessed,
        changed: fileStat.changed,
        entityType: EntityType.file,
        size: fileStat.size,
      );
      setState(() {
        children.add(storageItemModel);
        children.sort(
          (a, b) => b.modified.compareTo(a.modified),
        );
      });
    }
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (value) {
        fetchFilesList();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

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
          Expanded(
            child: children.isEmpty
                ? Center(
                    child: Text(
                      'No Files Here',
                      style: h4TextStyleInactive,
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: children.length,
                    itemBuilder: (context, index) => StorageItem(
                        storageItemModel: children[index],
                        onDirTapped: (path) {},
                        sizesExplorer: false,
                        parentSize: 0),
                  ),
          ),
          if (!foProvider.loadingOperation) EntityOperations(),
        ],
      ),
    );
  }
}
