// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/create_folder_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/explorer_provider.dart';
import 'package:explorer/providers/files_operations_provider.dart';
import 'package:explorer/screens/explorer_screen/widgets/entity_operations/operation_button.dart';
import 'package:explorer/screens/home_screen/widgets/modal_button_element.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path_operations;

class ChooseOperationContollers extends StatelessWidget {
  const ChooseOperationContollers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var foProviderFalse =
        Provider.of<FilesOperationsProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OperationButton(
            iconName: 'copy',
            onTap: () {
              foProviderFalse.setOperation(FileOparation.copy);
            }),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'scissors',
            onTap: () {
              foProviderFalse.setOperation(FileOparation.move);
            }),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'delete',
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => ModalWrapper(
                  showTopLine: false,
                  color: kCardBackgroundColor,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Confirm Delete',
                            style: h3TextStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Do you want to delete selected items?',
                            style: h4TextStyleInactive,
                          ),
                        ],
                      ),
                      VSpace(),
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWrapper(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: kHPad / 2, vertical: kVPad / 2),
                              backgroundColor: kBackgroundColor,
                              child: Text(
                                'Cancel',
                                style:
                                    h4TextStyle.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          HSpace(),
                          Expanded(
                            child: ButtonWrapper(
                              onTap: () {
                                //? here delete the items
                                Provider.of<FilesOperationsProvider>(context,
                                        listen: false)
                                    .performDelete();
                                Navigator.pop(context);
                              },
                              padding: EdgeInsets.symmetric(
                                  horizontal: kHPad / 2, vertical: kVPad / 2),
                              backgroundColor: kDangerColor,
                              child: Text(
                                'Delete',
                                style:
                                    h4TextStyle.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'dots',
            onTap: () {
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
                        opacity:
                            foProviderFalse.selectedItems.length == 1 ? 1 : .5,
                        active: foProviderFalse.selectedItems.length == 1,
                        title: 'Rename',
                        onTap: () {
                          Navigator.pop(ctx);
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (_) {
                                String oldName = path_operations.basename(
                                    Provider.of<FilesOperationsProvider>(
                                            context,
                                            listen: false)
                                        .selectedItems[0]
                                        .path);
                                return CreateFolderModal(
                                  oldName: oldName,
                                );
                              });
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
            }),
        HSpace(factor: .5),
        OperationButton(
            iconName: 'close1',
            onTap: () {
              var expProvider =
                  Provider.of<ExplorerProvider>(context, listen: false);
              foProviderFalse.clearAllSelectedItems(expProvider);
            }),
      ],
    );
  }
}
