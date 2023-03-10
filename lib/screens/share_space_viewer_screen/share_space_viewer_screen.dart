// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/show_modal_funcs.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/models/share_space_v_screen_data.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/screens/share_screen/widgets/empty_share_items.dart';
import 'package:explorer/screens/share_screen/widgets/not_sharing_view.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/current_path_viewer.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
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
  bool me = false;
  late ShareSpaceVScreenData data;
  bool loading = true;

//? to load shared items
  Future loadSharedItems([String? path]) async {
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    try {
      List<ShareSpaceItemModel> shareItems = [];
      if (data.laptop) {
        await localGetFolderContent('/', true);
      } else {
        shareItems = (await client_utils.getPeerShareSpace(
              data.peerModel!.sessionID,
              serverProviderFalse,
              shareProviderFalse,
              shareItemsExplorerProvider,
              data.peerModel!.deviceID,
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
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) async {
      data =
          ModalRoute.of(context)!.settings.arguments as ShareSpaceVScreenData;
      // bool means that it is from files explorer from windows device
      if (data.peerModel == null) {
        shareExpPF(context).setLaptopExploring(true);
        await connect_laptop_utils.getLaptopFolderContent(
          folderPath: '/',
          shareItemsExplorerProvider: shareExpPF(context),
          connectLaptopProvider: connectLaptopPF(context),
        );
        setState(() {
          loading = false;
        });
      } else {
        setState(() {
          shareExpPF(context).setLaptopExploring(data.laptop);
        });
        if (data.peerModel?.deviceID == sharePF(context).myDeviceId) {
          setState(() {
            me = true;
          });
        } else {
          loadSharedItems();
        }
      }
    });
  }

  String get title => shareExpP(context).loadingItems || loading
      ? '...'
      : data.laptop
          ? 'Laptop'
          : me
              ? 'Your Share Space'
              : '${data.peerModel!.name} Share Space';

  @override
  Widget build(BuildContext context) {
    // data = ModalRoute.of(context)!.settings.arguments as ShareSpaceVScreenData;

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
              title,
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
                        title: 'Other user share space is emptys',
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
                            shareSpaceItemModel:
                                shareExpProvider.viewedItems[index],
                            // to prevent clicking on the disk storages
                            onLongPressed: path_operations
                                    .basename(shareExpProvider
                                        .viewedItems[index].path)
                                    .contains(':')
                                ? null
                                : (path, entityType, network) {
                                    showDownloadFromShareSpaceModal(
                                      context,
                                      data.peerModel,
                                      index,
                                    );
                                  },
                            onFileTapped: (path) {
                              showDownloadFromShareSpaceModal(
                                context,
                                data.peerModel,
                                index,
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
      if (data.laptop) {
        await connect_laptop_utils.getLaptopFolderContent(
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
      logger.i(
          'Folder content loaded with length ${shareExpPF(context).viewedItems.length}');
    } catch (e) {
      logger.e(e);
      showSnackBar(
        context: context,
        message: 'Can\'t get this folder content',
        snackBarType: SnackBarType.error,
      );
    }
    setState(() {
      loading = false;
    });
  }
}
