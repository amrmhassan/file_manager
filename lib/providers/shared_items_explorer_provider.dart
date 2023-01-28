import 'package:explorer/models/share_space_item_model.dart';
import 'package:flutter/cupertino.dart';

class ShareItemsExplorerProvider extends ChangeNotifier {
  List<ShareSpaceItemModel> viewedItems = [];
  String? viewedUserSessionId;
  String? viewedUserDeviceId;
  bool myShareSpace = true;
}
