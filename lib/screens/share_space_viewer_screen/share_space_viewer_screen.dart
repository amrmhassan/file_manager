// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShareSpaceViewerScreen extends StatefulWidget {
  static const String routeName = '/ShareSpaceViewerScreen';
  const ShareSpaceViewerScreen({
    super.key,
  });

  @override
  State<ShareSpaceViewerScreen> createState() => _ShareSpaceViewerScreenState();
}

class _ShareSpaceViewerScreenState extends State<ShareSpaceViewerScreen> {
  PeerModel? remotePeerModel;
  bool loadingSharedItems = true;

//? to load shared items
  Future loadSharedItems([String? path]) async {
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    client_utils.getPeerShareSpace(
      remotePeerModel!.sessionID,
      serverProviderFalse,
      shareProviderFalse,
      shareItemsExplorerProvider,
      remotePeerModel!.deviceID,
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        remotePeerModel =
            ModalRoute.of(context)!.settings.arguments as PeerModel;
      });
      loadSharedItems();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shareExpProvider = Provider.of<ShareItemsExplorerProvider>(context);
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              shareExpProvider.loadingItems || (remotePeerModel == null)
                  ? '...'
                  : '${remotePeerModel!.name} Share Space',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
          ),
          if (shareExpProvider.currentPath != null)
            CurrentPathViewer(
              sizesExplorer: false,
              customPath: shareExpProvider.currentPath,
              onCopy: () {
                copyToClipboard(context, shareExpProvider.currentPath!);
              },
              onHomeClicked: () {
                Navigator.pushReplacementNamed(
                  context,
                  ShareSpaceViewerScreen.routeName,
                  arguments: remotePeerModel,
                );
              },
              onClickingSubPath: localGetFolderContent,
            ),
          shareExpProvider.loadingItems
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: shareExpProvider.viewedItems.length,
                    itemBuilder: (context, index) => StorageItem(
                      network: true,
                      onDirTapped: localGetFolderContent,
                      sizesExplorer: false,
                      parentSize: 0,
                      shareSpaceItemModel: shareExpProvider.viewedItems[index],
                      onFileTapped: (path) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => ModalWrapper(
                            padding: EdgeInsets.symmetric(
                              vertical: kVPad / 2,
                            ),
                            bottomPaddingFactor: 0,
                            afterLinePaddingFactor: 0,
                            showTopLine: false,
                            color: kBackgroundColor,
                            child: Column(
                              children: [
                                ModalButtonElement(
                                  inactiveColor: Colors.transparent,
                                  title: 'Download Now',
                                  onTap: () async {
                                    Provider.of<DownloadProvider>(
                                      context,
                                      listen: false,
                                    ).addDownloadTask(
                                      fileSize: shareExpProvider
                                          .viewedItems[index].size,
                                      remoteDeviceID: remotePeerModel!.deviceID,
                                      remoteFilePath: shareExpProvider
                                          .viewedItems[index].path,
                                      serverProvider: serverPF(context),
                                      shareProvider: sharePF(context),
                                      remoteDeviceName: remotePeerModel!.name,
                                    );
                                    Navigator.pop(context);
                                  },
                                ),
                                ModalButtonElement(
                                  showBottomLine: false,
                                  inactiveColor: Colors.transparent,
                                  title: 'Download to...',
                                  onTap: () async {
                                    // Provider.of<ClientProvider>(
                                    //   context,
                                    //   listen: false,
                                    // ).downloadFile(
                                    //   peerModel: peerModel!,
                                    //   savePath: 'sdcard/amh_download',
                                    //   remoteFilePath:
                                    //       shareExpProvider.viewedItems[index].path,
                                    //   sessionID: me(context).sessionID,
                                    //   deviceID: me(context).deviceID,
                                    // );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      allowSelect: false,
                    ),
                  ),
                ),
          VSpace(),
        ],
      ),
    );
  }

  void localGetFolderContent(String path) async {
    var shareExpProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    var serverProvider = Provider.of<ServerProvider>(context, listen: false);
    String userSessionID = shareExpProvider.viewedUserSessionId!;
    var shareProvider = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);
    client_utils.getFolderContent(
      serverProvider: serverProvider,
      folderPath: path,
      shareProvider: shareProvider,
      userSessionID: userSessionID,
      shareItemsExplorerProvider: shareItemsExplorerProvider,
    );
  }
}
