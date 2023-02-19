// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/download_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/connect_laptop_utils/connect_to_laptop_utils.dart'
    as connect_laptop_utils;
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class ShareSpaceVScreen extends StatefulWidget {
  static const String routeName = '/ShareSpaceViewerScreen';
  const ShareSpaceVScreen({
    super.key,
  });

  @override
  State<ShareSpaceVScreen> createState() => _ShareSpaceVScreenState();
}

class _ShareSpaceVScreenState extends State<ShareSpaceVScreen> {
  PeerModel? remotePeerModel;
  bool me = false;
  bool phone = false;

//? to load shared items
  Future loadSharedItems([String? path]) async {
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    try {
      List<ShareSpaceItemModel> shareItems = [];
      if (remotePeerModel!.phone) {
        await localGetFolderContent('/', true);
      } else {
        shareItems = (await client_utils.getPeerShareSpace(
              remotePeerModel!.sessionID,
              serverProviderFalse,
              shareProviderFalse,
              shareItemsExplorerProvider,
              remotePeerModel!.deviceID,
            )) ??
            [];
      }

      shareItemsExplorerProvider.setCurrentSharedItems(shareItems);
    } catch (e) {
      logger.e(e);
      Navigator.pop(context);
      showSnackBar(
        context: context,
        message: e.toString(),
        snackBarType: SnackBarType.error,
      );
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      var argument = ModalRoute.of(context)!.settings.arguments;
      // bool means that it is from files explorer from windows device
      if (argument is bool) {
        setState(() {
          phone = true;
        });
        connect_laptop_utils.getPhoneFolderContent(
          folderPath: '/',
          shareItemsExplorerProvider: shareExpPF(context),
          connectLaptopProvider: connectLaptopPF(context),
        );
      } else {
        setState(() {
          remotePeerModel =
              ModalRoute.of(context)!.settings.arguments as PeerModel;
          phone = remotePeerModel?.phone ?? false;
        });
        if (remotePeerModel?.deviceID == sharePF(context).myDeviceId) {
          setState(() {
            me = true;
          });
        } else {
          loadSharedItems();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var shareExpProvider = Provider.of<ShareItemsExplorerProvider>(context);
    String? parentPath = shareExpProvider.currentSharedFolderPath == null
        ? null
        : path_operations.dirname(shareExpProvider.currentSharedFolderPath!);
    String? viewPath =
        shareExpProvider.currentPath?.replaceFirst(parentPath ?? '', '');

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          CustomAppBar(
            title: Text(
              phone
                  ? 'Phone'
                  : shareExpProvider.loadingItems || (remotePeerModel == null)
                      ? '...'
                      : me
                          ? 'Your Share Space'
                          : '${remotePeerModel!.name} Share Space',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
          ),
          if (me) NotSharingView(),
          if (shareExpProvider.currentPath != null)
            CurrentPathViewer(
              sizesExplorer: false,
              customPath: viewPath,
              onCopy: () {
                copyToClipboard(context, viewPath!);
              },
              onHomeClicked: () {
                Navigator.pushReplacementNamed(
                  context,
                  ShareSpaceVScreen.routeName,
                  arguments: remotePeerModel ?? phone,
                );
              },
              onClickingSubPath: (path) => localGetFolderContent(path),
            ),
          if (!me)
            shareExpProvider.loadingItems
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        VSpace(),
                        Text(
                          'Waiting ...',
                          style: h4TextStyleInactive,
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: shareExpProvider.viewedItems.length,
                      itemBuilder: (context, index) => StorageItem(
                        network: true,
                        onDirTapped: localGetFolderContent,
                        sizesExplorer: false,
                        parentSize: 0,
                        shareSpaceItemModel:
                            shareExpProvider.viewedItems[index],
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
                                      try {
                                        await Provider.of<DownloadProvider>(
                                          context,
                                          listen: false,
                                        ).addDownloadTask(
                                          fileSize: shareExpProvider
                                              .viewedItems[index].size,
                                          remoteDeviceID:
                                              remotePeerModel!.deviceID,
                                          remoteFilePath: shareExpProvider
                                              .viewedItems[index].path,
                                          serverProvider: serverPF(context),
                                          shareProvider: sharePF(context),
                                          remoteDeviceName:
                                              remotePeerModel!.name,
                                        );
                                        Navigator.pop(context);
                                      } catch (e) {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              DoubleButtonsModal(
                                            onOk: () {},
                                            title: e.toString(),
                                          ),
                                        );
                                      }
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

  Future<void> localGetFolderContent(
    String path, [
    bool shareSpace = false,
  ]) async {
    try {
      if (phone) {
        await connect_laptop_utils.getPhoneFolderContent(
          folderPath: path,
          shareItemsExplorerProvider: shareExpPF(context),
          connectLaptopProvider: connectLaptopPF(context),
          shareSpace: shareSpace,
        );
      } else {
        var shareExpProvider =
            Provider.of<ShareItemsExplorerProvider>(context, listen: false);

        var serverProvider =
            Provider.of<ServerProvider>(context, listen: false);
        String userSessionID = shareExpProvider.viewedUserSessionId!;
        var shareProvider = Provider.of<ShareProvider>(context, listen: false);
        var shareItemsExplorerProvider =
            Provider.of<ShareItemsExplorerProvider>(context, listen: false);
        await client_utils.getFolderContent(
          serverProvider: serverProvider,
          folderPath: path,
          shareProvider: shareProvider,
          userSessionID: userSessionID,
          shareItemsExplorerProvider: shareItemsExplorerProvider,
        );
      }
    } catch (e) {
      logger.e(e);
      showSnackBar(
        context: context,
        message: 'Can\'t get this folder content',
        snackBarType: SnackBarType.error,
      );
    }
  }
}
