// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/change_my_name_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyNameWithEditWidget extends StatelessWidget {
  const MyNameWithEditWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var shareProvider = shareP(context);
    return PaddingWrapper(
      child: Row(
        children: [
          Expanded(
            child: Text(
              shareProvider.myName,
              style: h4TextStyleInactive,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          HSpace(),
          ButtonWrapper(
            borderRadius: 1000,
            padding: EdgeInsets.all(largePadding),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => ChangeMyNameModal(),
              );
            },
            child: Icon(
              FontAwesomeIcons.pen,
              color: kMainIconColor.withOpacity(.5),
              size: largeIconSize / 1.5,
            ),
          )
        ],
      ),
    );
  }
}
