import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';

class BaseOverLay extends StatelessWidget {
  // this will be clicked when no other element is being clicked
  final VoidCallback toggleControllerOverLayViewed;
  const BaseOverLay({
    super.key,
    required this.toggleControllerOverLayViewed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleControllerOverLayViewed,
          child: Opacity(
            opacity: 0,
            child: Container(
              height: Responsive.getCleanHeight(context),
              width: Responsive.getWidth(context),
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}
