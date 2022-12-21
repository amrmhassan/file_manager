// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, dead_code

import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entities_list_view_builder.dart';
import 'package:flutter/material.dart';

import 'package:explorer/screens/explorer_screen/widgets/empty_folder.dart';
import 'package:explorer/screens/home_screen/widgets/error_opening_folder.dart';
import 'package:provider/provider.dart';

class ChildrenViewList extends StatefulWidget {
  final bool sizesExplorer;

  const ChildrenViewList({
    super.key,
    this.sizesExplorer = false,
  });

  @override
  State<ChildrenViewList> createState() => _ChildrenViewListState();
}

class _ChildrenViewListState extends State<ChildrenViewList> {
  @override
  Widget build(BuildContext context) {
    var expProvider = Provider.of<ExplorerProvider>(context);
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);

    return expProvider.loadingChildren && expProvider.children.isEmpty
        ? Center(child: CircularProgressIndicator())
        : FutureBuilder(
            future: expProvider.viewedChildren(context, widget.sizesExplorer),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var viewedList = snapshot.data;
                if (viewedList == null) return EmptyFolder();
                return viewedList.isNotEmpty
                    ? EntitiesListViewBuilder(
                        sizesExplorer: widget.sizesExplorer,
                        viewedList: viewedList,
                      )
                    : expProviderFalse.error == null
                        ? (!expProviderFalse.loadingChildren
                            ? EmptyFolder()
                            : SizedBox())
                        : ErrorOpenFolder();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
