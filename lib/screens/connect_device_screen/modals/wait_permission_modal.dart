// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:explorer/constants/colors.dart';
import 'package:explorer/global/widgets/modal_wrapper/modal_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/models/permission_result_model.dart';
import 'package:explorer/models/types.dart';
import 'package:explorer/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class WaitPermissionModal extends StatefulWidget {
  final Future Function() callback;

  const WaitPermissionModal({
    super.key,
    required this.callback,
  });

  @override
  State<WaitPermissionModal> createState() => _WaitPermissionModalState();
}

class _WaitPermissionModalState extends State<WaitPermissionModal> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      try {
        var data = await widget.callback();
        Navigator.of(context).pop(
          PermissionResultModel(
            error: null,
            result: data,
          ),
        );
      } catch (e) {
        showSnackBar(
          context: context,
          message: (e as DioError).response?.data ?? 'Error Occurred',
          snackBarType: SnackBarType.error,
        );
        Navigator.of(context).pop(
          PermissionResultModel(
            error: e,
            result: null,
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      showTopLine: false,
      color: kCardBackgroundColor,
      child: Column(
        children: [
          CircularProgressIndicator(
            color: kMainIconColor,
            strokeWidth: 2,
          ),
          VSpace(),
          Text('loading-info'.i18n()),
        ],
      ),
    );
  }
}
