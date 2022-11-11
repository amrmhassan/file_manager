import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class SelectedItemNumber extends StatelessWidget {
  const SelectedItemNumber({
    Key? key,
    required this.foProvider,
  }) : super(key: key);

  final FilesOperationsProvider foProvider;

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      onTap: () {
        showSnackBar(
          context: context,
          message: 'I will show a modal of selected items here',
        );
      },
      alignment: Alignment.center,
      width: mediumIconSize,
      height: mediumIconSize,
      decoration: BoxDecoration(
        color: kLightCardBackgroundColor,
        borderRadius: BorderRadius.circular(mediumBorderRadius),
      ),
      child: Text(
        foProvider.selectedItems.length.toString(),
        style: h4TextStyle.copyWith(color: Colors.white),
      ),
    );
  }
}
