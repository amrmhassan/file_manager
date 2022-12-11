import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/models_constants.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/recent_opened_file_model.dart';
import 'package:explorer/providers/analyzer_provider.dart';
import 'package:explorer/screens/items_viewer_screen/items_viewer_screen.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//! you might convert all these calculations to run in isolate to view a loader
//? to get the data that will be viewed
Future<List<LocalFileInfo>> fetchData(
  ItemsType itemsType,
  BuildContext context,
) async {
  var analyzerProvider = Provider.of<AnalyzerProvider>(context, listen: false);

  List<LocalFileInfo> allFilesInfo =
      analyzerProvider.advancedStorageAnalyzer?.filesInfo ?? [];
  if (itemsType == ItemsType.bigFiles) {
    allFilesInfo.sort(
      (a, b) => b.size.compareTo(a.size),
    );
    allFilesInfo = allFilesInfo.sublist(0, 200);
    return allFilesInfo;
  } else if (itemsType == ItemsType.oldFiles) {
    allFilesInfo.sort(
      (a, b) => a.accessed.compareTo(b.accessed),
    );
    allFilesInfo = allFilesInfo.sublist(0, 200);
    return allFilesInfo;
  } else if (itemsType == ItemsType.modifiedFiles) {
    allFilesInfo.sort(
      (a, b) => a.modified.compareTo(b.modified),
    );
    allFilesInfo = allFilesInfo.sublist(0, 200);
    return allFilesInfo;
  } else if (itemsType == ItemsType.recentOpenedFiles) {
    var data = await DBHelper.getDataLimit(
      limit: 100,
      table: recentlyOpenedFilesTableName,
      databaseName: persistentDbName,
      orderASC: false,
      orderProp: dateFileOpenedString,
    );
    List<RecentOpenedFileModel> recentFiles = [];
    for (var element in data) {
      recentFiles.add(RecentOpenedFileModel.fromJSON(element));
    }
    return pathsToStorageItems(recentFiles.map((e) => e.path))
        .map((e) => e.toLocalFileInfo())
        .toList();
  } else {
    return [];
  }
}
