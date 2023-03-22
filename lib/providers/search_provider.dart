import 'package:explorer/constants/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:path/path.dart';

class SearchProvider extends ChangeNotifier {
  final List<String> _searchResults = [];
  List<String> get searchResults => [..._searchResults];
  bool emptySearch = false;
  bool searching = false;

  Future<void> search(String query) async {
    if (query.length < 2) return;
    _searchResults.clear();
    searching = true;
    notifyListeners();

    Iterable<String> allFolders =
        (await HiveBox.allFoldersInfoTableName).values.cast();
    Iterable<String> allFiles =
        (await HiveBox.allFilesInfoTableName).values.cast();

    _addToSearchResult(allFolders
        .where((element) => basename(element).contains(query))
        .toList());

    _addToSearchResult(allFiles
        .where((element) => basename(element).contains(query))
        .toList());

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
