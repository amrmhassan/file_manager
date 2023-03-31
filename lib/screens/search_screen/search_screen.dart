// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/screens_wrapper/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/entity_operations.dart';
import 'package:explorer/screens/search_screen/widgets/big_loading_search.dart';
import 'package:explorer/screens/search_screen/widgets/no_search_results.dart';
import 'package:explorer/screens/search_screen/widgets/search_results.dart';
import 'package:explorer/screens/search_screen/widgets/search_screen_app_bar.dart';
import 'package:explorer/screens/search_screen/widgets/searching_or_extend_search.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    var searchProvider = searchP(context);
    var foProvider = foPF(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          VSpace(),
          SearchScreenAppBar(),
          VSpace(),
          SearchingOrExtendSearch(),
          VSpace(factor: .5),
          Expanded(
            child: searchProvider.emptySearch
                ? NoSearchResults()
                : searchProvider.searching
                    ? BigLoadingSearch()
                    : SearchResults(),
          ),
          if (!foProvider.loadingOperation) EntityOperations(),
        ],
      ),
    );
  }
}
