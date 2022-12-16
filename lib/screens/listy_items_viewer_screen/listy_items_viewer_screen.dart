import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/db_constants.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/helpers/db_helper.dart';
import 'package:explorer/models/listy_item_model.dart';
import 'package:explorer/models/storage_item_model.dart';
import 'package:explorer/providers/listy_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/storage_item.dart';
import 'package:explorer/utils/models_transformer_utils.dart';
import 'package:flutter/material.dart';
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
        storageItems = pathsToStorageItems(i.map((e) => e.path));
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
            listyTitle,
            style: h2TextStyle,
          ),
        ),
        Expanded(
          child: ListView(
            children: storageItems
                .map((e) => StorageItem(
                      storageItemModel: e,
                      onDirTapped: (path) {},
                      sizesExplorer: false,
                      parentSize: 0,
                    ))
                .toList(),
          ),
        )
      ]),
    );
  }
}
