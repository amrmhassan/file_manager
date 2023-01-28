import 'package:explorer/models/peer_model.dart';
import 'package:explorer/models/share_space_item_model.dart';
import 'package:explorer/providers/server_provider.dart';
import 'package:explorer/providers/share_provider.dart';
import 'package:flutter/cupertino.dart';

class ShareItemsExplorerProvider extends ChangeNotifier {
  List<ShareSpaceItemModel> viewedItems = [];
  String? viewedUserSessionId;
  String? viewedUserDeviceId;
  bool myShareSpace = true;

  bool loadingItems = true;

//? to be called when asking for a user shared items
  void updateShareSpaceScreenInfo({
    required String viewedUserSessionId,
    required String viewedUserDeviceId,
    required List<ShareSpaceItemModel> viewedItems,
    required ServerProvider serverProvider,
    required ShareProvider shareProvider,
  }) {
    PeerModel me = serverProvider.me(shareProvider);
    this.viewedItems = [...viewedItems];
    this.viewedUserDeviceId = viewedUserDeviceId;
    this.viewedUserSessionId = viewedUserSessionId;
    myShareSpace = viewedUserDeviceId == me.deviceID;
    notifyListeners();
  }

  void setLoadingItems(bool i) {
    loadingItems = i;
    notifyListeners();
  }
}
