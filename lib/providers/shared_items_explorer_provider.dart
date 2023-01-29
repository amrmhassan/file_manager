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

// the current path that would be viewed in the other peer share space
  String? currentPath;

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
    currentPath = null;
    notifyListeners();
  }

//? to add some items to share space when the other peer add some
  void addToPeerShareSpaceScreen({
    required List<ShareSpaceItemModel> addedItems,
    required String sessionId,
  }) {
    if (viewedUserSessionId == sessionId) {
      for (var item in addedItems) {
        if (!viewedItems.any((element) => element.path == item.path)) {
          viewedItems.add(item);
        }
      }
      notifyListeners();
    }
  }

  //? remove some from share space item model
  void removeFromPeerShareSpace({
    required List<String> removedItems,
    required String sessionId,
  }) {
    if (viewedUserSessionId == sessionId) {
      for (var itemPath in removedItems) {
        viewedItems.removeWhere((element) => element.path == itemPath);
      }
      notifyListeners();
    }
  }

//? when getting a shared folder items, they need to be added to the screen
//? this function will do this job
  void updatePath(String path, List<ShareSpaceItemModel> items) {
    currentPath = path;
    viewedItems = items;
    notifyListeners();
  }

  void setLoadingItems(bool i, [bool notify = true]) {
    loadingItems = i;
    if (notify) notifyListeners();
  }
}
