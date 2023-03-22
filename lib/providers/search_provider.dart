import 'dart:async';

import 'package:explorer/analyzing_code/globals/files_folders_operations.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/isolates/folder_children_isolate_class.dart';
import 'package:flutter/foundation.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';

class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  void setSearchQuery(String v) {
    _searchQuery = v;
    notifyListeners();
  }

  final List<String> _searchResults = [];
  List<String> get searchResults => [..._searchResults];
  bool emptySearch = false;
  bool searching = false;

  Future<void> extendedSearch(String query) async {
    if (query.length < 2) return;
    _searchResults.clear();
    searching = true;
    notifyListeners();

    for (var dir in initialDirs) {
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

  Future<void> _handleRunParallelSearch(List<String> paths) async {
    Completer doneComplete = Completer();
    List<String> parallelFoldersEntries = [];
    List<String> completedSearches = [];
    for (var path in paths) {
      _addToSearchResult([path]);
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

  void _handleFilterSearchResults(Iterable<String> paths) {
    _addToSearchResult(
        paths.where((element) => element.contains(searchQuery)).toList());
  }

  Future<void> search() async {
    if (searchQuery.length < 2) return;
    _searchResults.clear();
    searching = true;
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
    logger.i('adding ${results.length} to search results');
    notifyListeners();
  }
}
