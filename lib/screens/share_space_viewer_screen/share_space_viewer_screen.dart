// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'dart:io';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/share_space_v_screen_data.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/share_screen/widgets/empty_share_items.dart';
import 'package:explorer/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class ShareSpaceVScreen extends StatefulWidget {
  static const String routeName = '/ShareSpaceViewerScreen';
  const ShareSpaceVScreen({
    super.key,
  });

  @override
  State<ShareSpaceVScreen> createState() => _ShareSpaceVScreenState();
  static _ShareSpaceVScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ShareSpaceVScreenState>();
}

class _ShareSpaceVScreenState extends State<ShareSpaceVScreen> {
  bool me = false;
  late ShareSpaceVScreenData data;
  bool loading = true;
  bool allowBuild = false;

  //? to load shared items
  Future loadSharedItems() async {
    setState(() {
      loading = true;
    });
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    try {
      List<ShareSpaceItemModel> shareItems = [];
      // this is for initial screen open and the mode is share space mode
      if (data.dataType == ShareSpaceVScreenDataType.shareSpace) {
        shareItems = (await client_utils.getPeerShareSpace(
              data.peerModel.sessionID,
              serverProviderFalse,
              shareProviderFalse,
              shareItemsExplorerProvider,
              data.peerModel.deviceID,
            )) ??
            [];
      } else if (data.dataType == ShareSpaceVScreenDataType.filesExploring) {
        // this is for initial screen open and the mode is files explore mode

        await localGetFolderContent('/');
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
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      data =
          ModalRoute.of(context)!.settings.arguments as ShareSpaceVScreenData;
      setState(() {
        allowBuild = true;
      });

      loadSharedItems();
      shareExpPF(context).clearCurrentSharedFolderPath();
    });
  }

  String get title => shareExpP(context).loadingItems || loading
      ? '...'
      : me
          ? 'your-share-space'.i18n()
          : data.dataType == ShareSpaceVScreenDataType.filesExploring
              ? '${data.peerModel.name} Files'
              : '${data.peerModel.name} Share Space';

  @override
  Widget build(BuildContext context) {
    if (!allowBuild) return SizedBox();

    var shareExpProvider = Provider.of<ShareItemsExplorerProvider>(context);
    String? parentPath = shareExpProvider.currentSharedFolderPath == null
        ? null
        : path_operations.dirname(shareExpProvider.currentSharedFolderPath!);
    String? viewPath =
        shareExpProvider.currentPath?.replaceFirst(parentPath ?? '', '');

    return WillPopScope(
      onWillPop: () => handleScreenGoBack(context),
      child: ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            // if (kDebugMode)
            //   Text(
            //     'parentPath ${parentPath.toString()}',
            //     style: h4TextStyle,
            //   ),
            // if (kDebugMode)
            //   Text(
            //     'viewPath ${viewPath.toString()}',
            //     style: h4TextStyle,
            //   ),
            // if (kDebugMode)
            //   Text(
            //     'mode ${data.dataType.name}',
            //     style: h4TextStyle,
            //   ),
            CustomAppBar(
              title: Text(
                title,
                style: h2TextStyle.copyWith(
                  color: kActiveTextColor,
                ),
              ),
              rightIcon: shareExpProvider.allowSelect
                  ? Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonWrapper(
                              padding: EdgeInsets.all(mediumPadding),
                              onTap: () {
                                var selectedItems =
                                    shareExpPF(context).selectedItems;
                                downPF(context).addMultipleDownloadTasks(
                                  remoteEntitiesPaths:
                                      selectedItems.map((e) => e.path),
                                  sizes: selectedItems.map((e) => e.size),
                                  remoteDeviceID: data.peerModel.deviceID,
                                  remoteDeviceName: data.peerModel.name,
                                  serverProvider: serverPF(context),
                                  shareProvider: sharePF(context),
                                  entitiesTypes: selectedItems.map(
                                    (e) => e.entityType,
                                  ),
                                );
                                shareExpPF(context).clearSelectedItems();
                              },
                              child: Image.asset(
                                'assets/icons/download.png',
                                width: mediumIconSize,
                              ),
                            ),
                          ],
                        ),
                        HSpace(),
                      ],
                    )
                  : null,
              leftIcon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: kDangerColor,
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
                    arguments: data,
                  );
                },
                onClickingSubPath: (path) => localGetFolderContent(path),
              ),
            if (!me)
              shareExpProvider.loadingItems || loading || loading
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
                  : shareExpProvider.viewedItems.isEmpty
                      ? Expanded(
                          child: EmptyShareItems(
                          title: 'Other user share space is empty',
                        ))
                      : Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: shareExpProvider.viewedItems.length,
                            itemBuilder: (context, index) => StorageItem(
                              network: true,
                              onDirTapped: localGetFolderContent,
                              sizesExplorer: false,
                              parentSize: 0,
                              exploreMode: ExploreMode.selection,
                              isSelected: shareExpProvider.isSelected(
                                  shareExpProvider.viewedItems[index].path),
                              shareSpaceItemModel:
                                  shareExpProvider.viewedItems[index],
                              onSelectClicked: () {
                                shareExpPF(context).toggleSelectItem(
                                  shareExpProvider.viewedItems[index],
                                );
                              },
                              // to prevent clicking on the disk storages
                              onLongPressed: (path, entityType, network) {
                                shareExpPF(context).toggleSelectItem(
                                  shareExpProvider.viewedItems[index],
                                );
                              },
                              onFileTapped: (path) {
                                showDownloadFromShareSpaceModal(
                                  context,
                                  data.peerModel,
                                  index,
                                );
                              },
                              allowSelect: shareExpProvider.allowSelect,
                            ),
                          ),
                        ),
            VSpace(),
          ],
        ),
      ),
    );
  }

// this is for clicking a folder item(in share space mode or file exploring mode)
  Future<void> localGetFolderContent(String path) async {
    try {
      var shareExpProvider =
          Provider.of<ShareItemsExplorerProvider>(context, listen: false);

      await client_utils.getDeviceFolderContent(
        folderPath: path,
        shareItemsExplorerProvider: shareExpProvider,
        peerModel: data.peerModel,
        shareSpace: false,
      );
      // }
    } catch (e) {
      logger.e(e);
      showSnackBar(
        context: context,
        message: 'Can\'t get this folder content',
        snackBarType: SnackBarType.error,
      );
    }
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<bool> handleScreenGoBack(BuildContext context) {
    var shareExpProvider = shareExpPF(context);
    String? parentPath = shareExpProvider.currentSharedFolderPath == null
        ? null
        : path_operations.dirname(shareExpProvider.currentSharedFolderPath!);
    String? viewPath =
        shareExpProvider.currentPath?.replaceFirst(parentPath ?? '', '');
    // this is for the first page of share space

    if (viewPath == null) return Future.value(true);
    if (data.dataType == ShareSpaceVScreenDataType.shareSpace) {
      // here i want to check if parent path is null then return true to exit
      if (parentPath == null) return Future.value(true);
      //
      // else i want to append parent to viewPath and go back
      String newPath = parentPath + viewPath;
      String previousPath = Directory(newPath).parent.path;
      //! but, here check if the previous path is allowed to be viewed or not
      if (previousPath == parentPath) {
        loadSharedItems();
        return Future.value(false);
      }
      //? here just go back
      localGetFolderContent(previousPath);
      return Future.value(false);
    } else {
      if (data.peerModel.deviceType == DeviceType.android &&
          (viewPath.split('/').length <= 4)) {
        return Future.value(true);
      }
      if (viewPath == '/') return Future.value(true);
      // just go back until the view path is '/'
      String newPath = Directory(viewPath).parent.path;
      if (newPath == '.') newPath = '/';
      localGetFolderContent(newPath);
      return Future.value(false);
    }
  }
}
