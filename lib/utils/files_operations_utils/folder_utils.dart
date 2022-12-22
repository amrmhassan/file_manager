//? to get a folder info
import 'package:explorer/analyzing_code/storage_analyzer/models/local_folder_info.dart';
import 'package:explorer/isolates/folder_info_isolates.dart';
import 'package:explorer/models/folder_details_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/foundation.dart';

void getFolderDetails({
  required StorageItemModel storageItemModel,
  required Function(
    FolderDetailsModel folderDetailsModel,
    int? oldSize,
  )
      callAfterAvailable,
  required Function() onDone,
}) async {
  String path = storageItemModel.path;
  FolderDetailsModel folderDetailsModel = FolderDetailsModel(path: path);
  // this won't return any size or files or folders
  callAfterAvailable(folderDetailsModel, null);

  LocalFolderInfo? localFolderInfo =
      await getFolderSizeFromDb(storageItemModel.path);
  if (localFolderInfo == null) {
    //? not saved in db
    FolderDetailsModel folderDetailsModel =
        await _getAndUpdateFolderDetails(path, storageItemModel);
    callAfterAvailable(folderDetailsModel, null);
    onDone();
  } else {
    //? saved in db
    folderDetailsModel.size = localFolderInfo.size;
    callAfterAvailable(folderDetailsModel, null);
    FolderDetailsModel latestFolderDetails =
        await _getAndUpdateFolderDetails(path, storageItemModel);
    callAfterAvailable(latestFolderDetails, localFolderInfo.size);
    onDone();
  }
}

//? to get folder details and update folder size
Future<FolderDetailsModel> _getAndUpdateFolderDetails(
    String path, StorageItemModel storageItemModel) async {
  FolderDetailsModel folderDetailsModel =
      await compute(calcFolderDetails, path);

  updateFolderSizeInSqlite(storageItemModel, folderDetailsModel.size!);

  return folderDetailsModel;
}
