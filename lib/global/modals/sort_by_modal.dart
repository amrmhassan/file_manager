// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:explorer/models/types.dart';

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
            title: "sort-name-a-z".i18n(),
            onTap: () => setSortOption(SortOption.nameAsc, context),
            checked: checked(SortOption.nameAsc, context),
          ),
          ModalButtonElement(
            title: "sort-name-z-a".i18n(),
            onTap: () => setSortOption(SortOption.nameDes, context),
            checked: checked(SortOption.nameDes, context),
          ),
          ModalButtonElement(
            title: "sort-modified-newest".i18n(),
            onTap: () => setSortOption(SortOption.modifiedDec, context),
            checked: checked(SortOption.modifiedDec, context),
          ),
          ModalButtonElement(
            title: "sort-modified-oldest".i18n(),
            onTap: () => setSortOption(SortOption.modifiedAsc, context),
            checked: checked(SortOption.modifiedAsc, context),
          ),
          ModalButtonElement(
            title: "sort-type-a-z".i18n(),
            onTap: () => setSortOption(SortOption.typeAsc, context),
            checked: checked(SortOption.typeAsc, context),
          ),
          ModalButtonElement(
            title: "sort-type-z-a".i18n(),
            onTap: () => setSortOption(SortOption.typeDec, context),
            checked: checked(SortOption.typeDec, context),
          ),
          ModalButtonElement(
            title: "sort-size-smallest".i18n(),
            onTap: () {
              setSortOption(SortOption.sizeAsc, context);
              showSnackBar(
                  context: context, message: 'size-exp_instead'.i18n());
            },
            checked: checked(SortOption.sizeAsc, context),
          ),
          ModalButtonElement(
            title: "sort-size-largest".i18n(),
            onTap: () {
              setSortOption(SortOption.sizeDec, context);
              showSnackBar(
                  context: context, message: 'size-exp_instead'.i18n());
            },
            checked: checked(SortOption.sizeDec, context),
          ),
          VSpace(),
        ],
      ),
    );
  }
}
