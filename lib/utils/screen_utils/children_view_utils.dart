import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/models/entity_clicked_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/models/types.dart';
import 'package:path/path.dart' as path;

//! i must refactor this to be a class and apply filters to let children pass through them and apply different factors
List<StorageItemModel> getFixedEntityList({
  required List<StorageItemModel> viewedChildren,
  required bool showHiddenFiles,
  required bool prioritizeFolders,
  required SortOption sortOption,
  List<EntityClickedModel>? factoringItems,
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
  } else if (sortOption == SortOption.frequentlyOpened) {
    List<EntityClickedModel> arrangeList = [...factoringItems!];
    //! here i will sort according to frequently opened
    for (var storageItemModel in viewedChildren) {
      EntityClickedModel arrangeModel = arrangeList
          .firstWhere((element) => element.path == storageItemModel.path);
      double arrangeFactor = getArrangeFactor(arrangeModel);
      storageItemModel.arrangeFactor = arrangeFactor;
      storageItemModel.dateClicked =
          DateTime.parse(arrangeModel.lastTimeClicked);
    }
    viewedChildren.sort(
      (a, b) {
        int factorComparison = b.arrangeFactor.compareTo(a.arrangeFactor);
        if (factorComparison != 0) {
          return factorComparison;
        }
        if (a.arrangeFactor == b.arrangeFactor) {
          return b.dateClicked!.compareTo(a.dateClicked!);
        }

        return a.path.compareTo(b.path);
        //تفسير
        //afm
        //idm
      },
    );
  } else {
    // if there is no sorting option or a wrong option is selected
    viewedChildren.sort(
      (a, b) => a.path.compareTo(b.path),
    );
  }
  // logger.i('Sorting done according to ${sortOption.name}');

  //? for folders first
  if (prioritizeFolders) {
    //* folders
    List<StorageItemModel> fd = [
      ...viewedChildren
          .where((element) => element.entityType == EntityType.folder)
    ];
    //* files
    List<StorageItemModel> fl = [
      ...viewedChildren
          .where((element) => element.entityType == EntityType.file)
    ];

    fixedEntities.addAll(fd);
    fixedEntities.addAll(fl);
  } else {
    fixedEntities = [...viewedChildren];
  }

  return fixedEntities;
}

double getArrangeFactor(EntityClickedModel arrangeModel) {
  int minDiff = DateTime.now()
      .difference(DateTime.parse(arrangeModel.lastTimeClicked))
      .inMinutes;
  double arrangeFactor = arrangeModel.times == 0
      ? double.negativeInfinity
      : (arrangeModel.times - minDiff).toDouble();
  return arrangeFactor;
}


// actually the sorting according to frequently usage run like this
// when clicking the item his factor increases by one
// if the factor is actual sorting factor will be negative to allow sorting for older clicked elements as well
// if factor is -inf this mean it never clicked
// if no action from the user or clicking on any items, the items stay in the same position but of course the factor will decrease by 1 each minute
// when two items have the same factor, the priority will be for the latest clicked item
// when clicking an item, if it's factor isn't positive, it will be set to 0 then increased to 1=> means it's factor will be one
// -- this prevent from burring old clicked elements and count from let's say-100 or so to be on the top again
// -- this is useful to make the old clicked elements to count just like the -inf elements which was never clicked
// and the new factor that will be saved will come from the factoring formula called by function double getArrangeFactor(EntityClickedModel arrangeModel)
// when clicking an element
// -- if it's factor is -inf(first time) , factor will be 1 and saved
// -- if it's factor is positive , factor will be increased by 1 and saved
// -- if it's factor is negative, factor will 1 and saved