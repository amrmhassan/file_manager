import 'dart:async';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/isolates/folder_children_isolate_class.dart';
import 'package:flutter/foundation.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:path/path.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  bool extendSearchDone = false;

  void setExtendedSearchDone(bool s) {
    extendSearchDone = s;
    notifyListeners();
  }

  void setSearchQuery(String v) {
    _searchQuery = v.trim();
    notifyListeners();
  }

  final List<String> _searchResults = [];
  List<String> get searchResults => [..._searchResults];
  bool emptySearch = false;
  bool searching = false;

  Future<void> extendedSearch() async {
    if (searchQuery.length < 2) return;
    emptySearch = false;
    _searchResults.clear();
    searching = true;
    extendSearchDone = true;
    notifyListeners();

    for (var dir in initialDirs.skip(1)) {
      if (dir.path == initialDirs.first.path) continue;
      // searching for the full storage path
      // split the storage and get the folders and start a separate search for each folder to fasten the process
      var firstGenChildren = await compute(
        (message) => FolderChildrenIsolate.getFolderChildrenAsPaths(message),
        dir.path,
      );
      // after the first gen getting, start parallel search for each sub path
      await _handleRunParallelSearch(firstGenChildren);

      searching = false;
      emptySearch = _searchResults.isEmpty;
      notifyListeners();
    }
  }

  Future<void> search() async {
    if (searchQuery.length < 2) return;
    _searchResults.clear();
    searching = true;
    emptySearch = false;
    extendSearchDone = false;
    notifyListeners();

    Iterable<String> allFolders =
        (await HiveBox.allFoldersInfoTableName).values.cast();
    Iterable<String> allFiles =
        (await HiveBox.allFilesInfoTableName).values.cast();

    _handleFilterSearchResults(allFolders);
    _handleFilterSearchResults(allFiles);

    searching = false;
    emptySearch = _searchResults.isEmpty;
    notifyListeners();
  }

  void _addToSearchResult(List<String> results) {
    _searchResults.addAll(results);
    notifyListeners();
  }

  void _handleFilterSearchResults(Iterable<String> paths) {
    var res = paths
        .where((element) =>
            basename(element).toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    _addToSearchResult(res);
  }

  Future<void> _handleRunParallelSearch(List<String> paths) async {
    Completer doneComplete = Completer();
    List<String> parallelFoldersEntries = [];
    List<String> completedSearches = [];

    for (var path in paths) {
      _handleFilterSearchResults([path]);
      bool isPathDir = isDir(path);
      if (isPathDir) {
        parallelFoldersEntries.add(path);
      }
    }
    // after filtering, start search
    for (var entry in parallelFoldersEntries) {
      compute(
        (message) =>
            FolderChildrenIsolate.getFolderChildrenAsPathsRecursive(message),
        entry,
      ).then((res) {
        // here start filtering the results, then add the result to the search results
        _handleFilterSearchResults(res);
        // complete the completer to return from the future with the results
        completedSearches.add(entry);
        if (completedSearches.length == parallelFoldersEntries.length) {
          doneComplete.complete();
        }
      });
    }
    return doneComplete.future;
  }
}
