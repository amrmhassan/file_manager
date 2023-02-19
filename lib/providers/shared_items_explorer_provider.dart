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
  // this will hold the shared items of the device that we are currently viewing it's shared items, this won't be changed for one user until next load of his items
  // when init state of share items viewer screen
  List<ShareSpaceItemModel> currentSharedSpaceItems = [];

  void setCurrentSharedItems(List<ShareSpaceItemModel> items) {
    currentSharedSpaceItems = [...items];
  }

  // the current path that would be viewed in the other peer share space items viewed on the screen are direct children of this folder
  String? currentPath;

  // the main parent that is a folder from the share space and won't be changed until entering another folder inside a share space of that peer
  // i need this to protect the upper parents of this children to be hidden from the path because i shouldn't view the previous folders of the shared folder
  String? currentSharedFolderPath;

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
      currentSharedSpaceItems.addAll(addedItems);
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
        currentSharedSpaceItems
            .removeWhere((element) => element.path == itemPath);
      }
      notifyListeners();
    }
  }

  //? when getting a shared folder items, they need to be added to the screen
  //? this function will do this job
  void updatePath(String? path, List<ShareSpaceItemModel> items) {
    currentPath = path;
    viewedItems = items;
    notifyListeners();

    // to check if i am entering a main entity(main shared item not a children of another shared item) directly shared
    if (currentSharedSpaceItems.any((element) => element.path == path)) {
      currentSharedFolderPath = path;
      notifyListeners();
    }
  }

  void setLoadingItems(bool i, [bool notify = true]) {
    loadingItems = i;
    if (notify) notifyListeners();
  }
}
