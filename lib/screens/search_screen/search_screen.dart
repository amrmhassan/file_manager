// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/analyzing_code/storage_analyzer/models/local_file_info.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_text_field.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/futures_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  CustomFuture? customFuture;

  @override
  Widget build(BuildContext context) {
    var searchProviderFalse = searchPF(context);
    var searchProvider = searchP(context);

    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(
        children: [
          VSpace(),
          Row(
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
          ),
          VSpace(),
          if (searchProvider.searching)
            PaddingWrapper(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Searching...'),
                  Spacer(),
                  SizedBox(
                    width: smallIconSize,
                    height: smallIconSize,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            )
          else if (!searchProvider.extendSearchDone)
            PaddingWrapper(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ButtonWrapper(
                    onTap: () {
                      searchProviderFalse.extendedSearch();
                    },
                    child: Text(
                      'Extended Search?',
                      style: h4TextStyle.copyWith(color: kBlueColor),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          VSpace(factor: .5),
          Expanded(
            child: searchProvider.emptySearch
                ? Center(
                    child: Text(
                      'No Search Results!',
                      style: h4TextStyleInactive,
                    ),
                  )
                : searchProvider.searching
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: double.infinity),
                            Text(
                              'Searching...',
                              style: h4TextStyleInactive,
                            ),
                            VSpace(factor: .5),
                            SizedBox(
                              width: largeIconSize,
                              height: largeIconSize,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: searchProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          StorageItemModel storageItemModel =
                              LocalFileInfo.fromPath(
                                      searchProvider.searchResults[index])
                                  .toStorageItemModel();
                          return StorageItem(
                            onDirTapped: (p) {},
                            sizesExplorer: false,
                            parentSize: 0,
                            storageItemModel: storageItemModel,
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}
