import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/screens/selected_items_screen/selected_items_screen.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class SelectedItemNumber extends StatelessWidget {
  const SelectedItemNumber({
    Key? key,
    this.tap = true,
  }) : super(key: key);

  final bool tap;

  @override
  Widget build(BuildContext context) {
    var foProvider = foP(context);
    return ButtonWrapper(
      onTap: tap
          ? () {
              Navigator.pushNamed(context, SelectedItemsScreen.routeName);
            }
          : null,
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
