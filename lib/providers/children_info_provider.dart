import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/folder_item_info_model.dart';
import 'package:explorer/models/folder_scroll_model.dart';
import 'package:flutter/cupertino.dart';

class ChildrenItemsProvider extends ChangeNotifier {
  //# folder items info
  List<FolderItemInfoModel> foldersInfo = [];
  Future<void> addFolderInfo(FolderItemInfoModel folderItemInfoModel) async {
    foldersInfo.add(folderItemInfoModel);
    await DBHelper.insert(folderInfoTableName, folderItemInfoModel.toJSON());
    notifyListeners();
  }

  FolderItemInfoModel? getFolderInfo(String path) {
    try {
      return foldersInfo.firstWhere((element) => path == element.path);
    } catch (e) {
      return null;
    }
  }

  Future<void> getAndUpdataAllSavedFolders() async {
    foldersInfo.clear();
    var data = await DBHelper.getData(folderInfoTableName);
    foldersInfo = data.map((e) => FolderItemInfoModel.fromJSON(e)).toList();
    notifyListeners();
  }

//# folder scroll (only with state, no db saving unless it is needed in the future)
  List<FolderScrollModel?> foldersScrolling = [];
  void setFolderScroll(String path, double offset) {
    foldersScrolling.removeWhere((element) => element?.path == path);
    FolderScrollModel folderScrollModel =
        FolderScrollModel(offset: offset, path: path);
    foldersScrolling.add(folderScrollModel);
    notifyListeners();
  }

  double? getScrollingPosition(String path) {
    FolderScrollModel? folderScrollModel = foldersScrolling
        .firstWhere((element) => element?.path == path, orElse: () => null);
    return folderScrollModel?.offset;
  }
}
