// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/global_constants.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/choose_operation_controllers.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/perform_paste_operation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double _height = 75;
// an error happen here, when the container heigt is lowered to zero it's children give RenderFlex overflow

class EntityOperations extends StatelessWidget {
  const EntityOperations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProvider = Provider.of<FilesOperationsProvider>(context);

    return AnimatedContainer(
      clipBehavior: Clip.hardEdge,
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
      child: foProvider.currentOperation == null
          ? ChooseOperationControllers()
          : PerformPasteOperationContoller(),
    );
  }
}
