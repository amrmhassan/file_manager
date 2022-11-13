// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/modals/create_folder_modal.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class EntityOptions extends StatelessWidget {
  const EntityOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return OperationButton(
        iconName: 'dots',
        onTap: () async {
          //? entity options modal
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) => ModalWrapper(
              afterLinePaddingFactor: 0,
              bottomPaddingFactor: 0,
              padding: EdgeInsets.zero,
              color: kCardBackgroundColor,
              showTopLine: false,
              borderRadius: mediumBorderRadius,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(),
                  ModalButtonElement(
                    inactiveColor: Colors.transparent,
                    opacity: foProviderFalse.selectedItems.length == 1 ? 1 : .5,
                    active: foProviderFalse.selectedItems.length == 1,
                    title: 'Rename',
                    onTap: () async {
                      //? rename modal
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (_) {
                            String oldName = path_operations.basename(
                                Provider.of<FilesOperationsProvider>(context,
                                        listen: false)
                                    .selectedItems[0]
                                    .path);
                            return CreateFolderModal(
                              oldName: oldName,
                            );
                          });
                      Navigator.pop(ctx);
                    },
                  ),
                  ModalButtonElement(
                    title: 'Details',
                    onTap: () {},
                  ),
                  VSpace(),
                ],
              ),
            ),
          );
        });
  }
}
