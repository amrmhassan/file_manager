// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/defaults_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/models/listy_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:explorer/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

class ListyItemViewerScreen extends StatefulWidget {
  static const String routeName = '/ListyItemViewerScreen';
  const ListyItemViewerScreen({super.key});

  @override
  State<ListyItemViewerScreen> createState() => _ListyItemViewerScreenState();
}

class _ListyItemViewerScreenState extends State<ListyItemViewerScreen> {
  bool loading = true;
  String listyTitle = '';
  List<ListyItemModel> listyItems = [];
  List<StorageItemModel> storageItems = [];

  Future<List<ListyItemModel>> fetchData(String listyTitle) async {
    List<ListyItemModel> li =
        await Provider.of<ListyProvider>(context, listen: false)
            .getListyItems(listyTitle);
    return li;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      String lt = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        listyTitle = lt;
      });
      List<ListyItemModel> i = await fetchData(lt);
      setState(() {
        loading = false;
        listyItems = i;
        storageItems = pathsToStorageItemsWithType(
                i.map((e) => {'path': e.path, 'type': e.entityType}))
            .reversed
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(children: [
        CustomAppBar(
          title: Text(
            listyTitle == defaultListyList.first.title
                ? 'favorite'.i18n()
                : listyTitle,
            style: h2TextStyle,
          ),
        ),
        loading
            ? CircularProgressIndicator()
            : storageItems.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no-items-here'.i18n(),
                          style: h4TextStyleInactive,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: storageItems
                          .map((e) => Dismissible(
                                key: Key(e.path),
                                confirmDismiss: (direction) async {
                                  bool returnValue = false;
                                  await showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (ctx) => DoubleButtonsModal(
                                      onOk: () async {
                                        returnValue = true;
                                        await Provider.of<ListyProvider>(
                                                context,
                                                listen: false)
                                            .removeItemFromListy(
                                          path: e.path,
                                          listyTitle: listyTitle,
                                        );
                                        setState(() {
                                          storageItems.removeWhere((element) =>
                                              element.path == e.path);
                                        });
                                      },
                                      okText: 'Remove',
                                      title: 'Remove This item?',
                                    ),
                                  );
                                  return returnValue;
                                },
                                child: StorageItem(
                                  allowSelect: false,
                                  storageItemModel: e,
                                  onDirTapped: (path) =>
                                      handleOpenTabFromOtherScreen(
                                          path, context),
                                  sizesExplorer: false,
                                  parentSize: 0,
                                ),
                              ))
                          .toList(),
                    ),
                  )
      ]),
    );
  }
}
