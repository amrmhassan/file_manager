// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/modals/double_buttons_modal.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:explorer/global/widgets/screens_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:explorer/screens/single_user_permissions_screen/single_user_permissions_screen.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class UsersPermissionScreen extends StatelessWidget {
  static const String routeName = '/UsersPermissionScreen';
  const UsersPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var permissionsProvider = permissionsP(context);

    return ScreensWrapper(
        backgroundColor: kBackgroundColor,
        child: Column(
          children: [
            CustomAppBar(
              title: Text(
                'Known Users',
                style: h2TextStyle,
              ),
            ),
            VSpace(),
            permissionsProvider.peersPermissions.isEmpty
                ? Expanded(
                    child: Center(
                    child: Text(
                      'no-devices'.i18n(),
                      style: h4TextStyle,
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: permissionsProvider.peersPermissions.length,
                    itemBuilder: (context, index) {
                      PeerPermissionsModel peerPermissionsModel =
                          permissionsProvider.peersPermissions[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          bool? res = await showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => DoubleButtonsModal(
                              autoPop: false,
                              onCancel: () {
                                Navigator.pop(context);
                              },
                              onOk: () {
                                Navigator.pop(context, true);
                              },
                              title: 'Remove known user?',
                              subTitle:
                                  'This will remove all saved permissions for this user',
                            ),
                          );
                          if (res == true) {
                            await permissionsPF(context)
                                .deleteAllUserPermissions(
                              peerPermissionsModel.peerDeviceID,
                            );
                            showSnackBar(
                              context: context,
                              message: 'All user permissions deleted',
                            );
                          }

                          return res == true;
                        },
                        background: Container(
                          padding: EdgeInsets.only(right: kHPad),
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ButtonWrapper(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              SingleUserPermissionsScreen.routeName,
                              arguments: peerPermissionsModel.peerDeviceID,
                            );
                          },
                          alignment: Alignment.centerLeft,
                          borderRadius: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: kHPad * .8,
                            vertical: kVPad / 2,
                          ),
                          child: Row(
                            children: [
                              Text(
                                peerPermissionsModel.peerName,
                                style: h4TextStyle,
                              ),
                              Expanded(
                                child: Text(
                                  peerPermissionsModel.peerDeviceID,
                                  style: h5InactiveTextStyle,
                                  textAlign: TextAlign.end,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ))
          ],
        ));
  }
}
