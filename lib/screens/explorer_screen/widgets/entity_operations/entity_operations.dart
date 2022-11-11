// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double _height = 75;

class EntityOperations extends StatelessWidget {
  const EntityOperations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);
    return AnimatedContainer(
      transform: Matrix4.translationValues(
        0,
        foProvider.selectedItems.isEmpty ? _height : 0,
        0,
      ),
      duration: bottomActionsDuration,
      width: double.infinity,
      height: foProvider.selectedItems.isEmpty ? 0 : _height,
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        border: Border(
          top: BorderSide(
            color: kInactiveColor.withOpacity(.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: kBackgroundColor,
            offset: Offset(0, 0),
            blurRadius: 15,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWrapper(
                borderRadius: 599,
                padding: EdgeInsets.all(ultraLargePadding),
                onTap: () {},
                child: Image.asset(
                  'assets/icons/dots.png',
                  width: smallIconSize,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
