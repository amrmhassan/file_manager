import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/explorer_provider_abstract.dart';
import 'package:path/path.dart' as path;

List<StorageItemModel> getFixedEntityList({
  required List<StorageItemModel> viewedChildren,
  required bool showHiddenFiles,
  required bool prioritizeFolders,
  required SortOption sortOption,
}) {
  //? for hidden files
  if (!showHiddenFiles) {
    viewedChildren = viewedChildren.where(
      (element) {
        return !path.basename(element.path).startsWith('.');
      },
    ).toList();
  }
  List<StorageItemModel> fixedEntities = [];
  //? for sorting options
  if (sortOption == SortOption.nameAsc) {
    viewedChildren.sort(
      (a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()),
    );
  } else if (sortOption == SortOption.nameDes) {
    viewedChildren.sort(
      (a, b) => b.path.toLowerCase().compareTo(a.path.toLowerCase()),
    );
  } else if (sortOption == SortOption.modifiedAsc) {
    viewedChildren.sort(
      (a, b) => a.modified.compareTo(b.modified),
    );
  } else if (sortOption == SortOption.modifiedDec) {
    viewedChildren.sort(
      (a, b) => b.modified.compareTo(a.modified),
    );
  } else if (sortOption == SortOption.typeAsc) {
    viewedChildren.sort(
      (a, b) => getFileExtension(a.path.toLowerCase())
          .compareTo(getFileExtension(b.path.toLowerCase())),
    );
  } else if (sortOption == SortOption.typeDec) {
    viewedChildren.sort(
      (a, b) => getFileExtension(b.path).compareTo(getFileExtension(a.path)),
    );
  } else if (sortOption == SortOption.sizeAsc) {
    viewedChildren.sort(
      (a, b) {
        if (a.size == null && b.size == null) {
          return a.path.compareTo(b.path);
        } else {
          return (a.size ?? 0).compareTo(b.size ?? 0);
        }
      },
    );
  } else if (sortOption == SortOption.sizeDec) {
    viewedChildren.sort(
      (a, b) {
        if (a.size == null && b.size == null) {
          return b.path.compareTo(a.path);
        } else {
          return (b.size ?? 0).compareTo(a.size ?? 0);
        }
      },
    );
  } else {
    // if there is no sorting option or a worng option is selected
    viewedChildren.sort(
      (a, b) => a.path.compareTo(b.path),
    );
  }
  //? for folders first
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
