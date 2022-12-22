// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/explorer_provider_abstract.dart';
import 'package:explorer/providers/util/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortByModal extends StatelessWidget {
  const SortByModal({
    Key? key,
  }) : super(key: key);

  bool? checked(SortOption s, BuildContext context) {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    if (expProviderFalse.sortOption == s) {
      return true;
    }
    return null;
  }

  void setSortOption(SortOption s, BuildContext context) {
    var expProviderFalse =
        Provider.of<ExplorerProvider>(context, listen: false);
    expProviderFalse.setSortOptions(s);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      color: kCardBackgroundColor,
      afterLinePaddingFactor: 0,
      bottomPaddingFactor: 0,
      padding: EdgeInsets.zero,
      showTopLine: false,
      borderRadius: mediumBorderRadius,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VSpace(),
          ModalButtonElement(
            title: 'Name ( A to Z )',
            onTap: () => setSortOption(SortOption.nameAsc, context),
            checked: checked(SortOption.nameAsc, context),
          ),
          ModalButtonElement(
            title: 'Name ( Z to A )',
            onTap: () => setSortOption(SortOption.nameDes, context),
            checked: checked(SortOption.nameDes, context),
          ),
          ModalButtonElement(
            title: 'Modified ( newest first )',
            onTap: () => setSortOption(SortOption.modifiedDec, context),
            checked: checked(SortOption.modifiedDec, context),
          ),
          ModalButtonElement(
            title: 'Modified ( oldest first )',
            onTap: () => setSortOption(SortOption.modifiedAsc, context),
            checked: checked(SortOption.modifiedAsc, context),
          ),
          ModalButtonElement(
            title: 'Type ( A to Z )',
            onTap: () => setSortOption(SortOption.typeAsc, context),
            checked: checked(SortOption.typeAsc, context),
          ),
          ModalButtonElement(
            title: 'Type ( Z to A )',
            onTap: () => setSortOption(SortOption.typeDec, context),
            checked: checked(SortOption.typeDec, context),
          ),
          ModalButtonElement(
            title: 'Size ( smallest first )',
            onTap: () {
              setSortOption(SortOption.sizeAsc, context);
              showSnackBar(
                  context: context,
                  message: 'You can use size explorer instead');
            },
            checked: checked(SortOption.sizeAsc, context),
          ),
          ModalButtonElement(
            title: 'Size ( largest first )',
            onTap: () {
              setSortOption(SortOption.sizeDec, context);
              showSnackBar(
                  context: context,
                  message: 'You can use size explorer instead');
            },
            checked: checked(SortOption.sizeDec, context),
          ),
          VSpace(),
        ],
      ),
    );
  }
}
