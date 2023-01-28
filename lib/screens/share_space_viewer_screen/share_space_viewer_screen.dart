// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/client_provider.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:explorer/providers/shared_items_explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
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
  PeerModel? peerModel;
  bool loadingSharedItems = true;

//? to load shared items
  Future loadSharedItems([String? path]) async {
    var serverProviderFalse =
        Provider.of<ServerProvider>(context, listen: false);
    var shareProviderFalse = Provider.of<ShareProvider>(context, listen: false);
    var shareItemsExplorerProvider =
        Provider.of<ShareItemsExplorerProvider>(context, listen: false);

    await Provider.of<ClientProvider>(context, listen: false).getPeerShareSpace(
      peerModel!.sessionID,
      serverProviderFalse,
      shareProviderFalse,
      shareItemsExplorerProvider,
      peerModel!.deviceID,
    );
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        peerModel = ModalRoute.of(context)!.settings.arguments as PeerModel;
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
              shareExpProvider.loadingItems || (peerModel == null)
                  ? '...'
                  : '${peerModel!.name} Share Space',
              style: h2TextStyle.copyWith(
                color: kActiveTextColor,
              ),
            ),
          ),
          shareExpProvider.loadingItems
              ? Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                  child: ListView.builder(
                    itemCount: shareExpProvider.viewedItems.length,
                    itemBuilder: (context, index) => StorageItem(
                      onDirTapped: (p) {},
                      sizesExplorer: false,
                      parentSize: 0,
                      shareSpaceItemModel: shareExpProvider.viewedItems[index],
                    ),
                  ),
                ),
          VSpace(),
        ],
      ),
    );
  }
}
