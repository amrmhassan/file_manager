// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/futures_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SearchScreenAppBar extends StatefulWidget {
  const SearchScreenAppBar({
    super.key,
  });

  @override
  State<SearchScreenAppBar> createState() => _SearchScreenAppBarState();
}

class _SearchScreenAppBarState extends State<SearchScreenAppBar> {
  TextEditingController searchController = TextEditingController();
  CustomFuture? customFuture;

  @override
  void initState() {
    searchController.text = searchPF(context).searchQuery;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var searchProviderFalse = searchPF(context);
    var searchProvider = searchP(context);

    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(
                width: 1,
                color: kMainIconColor.withOpacity(.5),
              ),
            ),
            controller: searchController,
            borderColor: kMainIconColor.withOpacity(.6),
            autoFocus: true,
            title: 'Search...',
            enabled: !searchProvider.searching,
            onChange: (v) {
              searchProviderFalse.setSearchQuery(v);
              customFuture?.cancel();
              customFuture = CustomFuture();
              customFuture?.delayedAction(Duration(milliseconds: 700),
                  () async {
                searchProviderFalse.search();
              });
            },
            trailingIcon: searchProvider.searchQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      searchProviderFalse.setSearchQuery('');
                      searchController.text = '';
                    },
                    icon: Icon(
                      Icons.close,
                      color: kDangerColor,
                    ),
                  ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_forward,
            color: kMainIconColor,
          ),
        ),
        HSpace(),
      ],
    );
  }
}
