import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:path/path.dart' as path;

List<StorageItemModel> getFixedEntityList(
  List<StorageItemModel> viewedChildren,
) {
  if (!showHiddenFiles) {
    viewedChildren = viewedChildren.where(
      (element) {
        return !path.basename(element.path).startsWith('.');
      },
    ).toList();
  }
  List<StorageItemModel> fixedEntities = [];
  if (sortAlphapitacally) {
    viewedChildren.sort(
      (a, b) => a.path.compareTo(b.path),
    );
  }
  if (prioritizeFolders) {
    //* folders
    List<StorageItemModel> fd = [
      ...viewedChildren.where((element) => isDir(element.path))
    ];
    //* files
    List<StorageItemModel> fl = [
      ...viewedChildren.where((element) => isFile(element.path))
    ];

    fixedEntities.addAll(fd);
    fixedEntities.addAll(fl);
  } else {
    fixedEntities = [...viewedChildren];
  }

  return fixedEntities;
}
