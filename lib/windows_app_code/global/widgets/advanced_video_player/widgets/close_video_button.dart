// ignore_for_file: prefer_const_constructors

import '../../../../utils/windows_provider_calls.dart';
import './custom_icon_button.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CloseVideoButton extends StatelessWidget {
  const CloseVideoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpFalse = WindowSProviders.mpPF(context);
    return SafeArea(
      child: Column(
        children: [
          VSpace(),
          CustomIconButton(
            color: Colors.white.withOpacity(.8),
            onTap: () {
              mpFalse.closeVideo();
            },
            iconData: FontAwesomeIcons.xmark,
          ),
        ],
      ),
    );
  }
}
