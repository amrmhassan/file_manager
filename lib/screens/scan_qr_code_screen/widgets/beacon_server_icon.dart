// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/models/beacon_server_model.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class BeaconServerIcon extends StatefulWidget {
  final BeaconServerModel beaconServerModel;
  const BeaconServerIcon({
    super.key,
    required this.beaconServerModel,
  });

  @override
  State<BeaconServerIcon> createState() => _BeaconServerIconState();
}

class _BeaconServerIconState extends State<BeaconServerIcon> {
  @override
  void initState() {
    beaconPF(context)
        .askForBeaconServerImage(beaconServerUrl: widget.beaconServerModel.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // no image
    return widget.beaconServerModel.noImage
        ? Container(
            clipBehavior: Clip.hardEdge,
            width: largeIconSize,
            height: largeIconSize,
            padding: EdgeInsets.all(largePadding * .8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Image.asset(
              'assets/icons/user.png',
              color: kCardBackgroundColor.withOpacity(1),
            ),
          )
        : widget.beaconServerModel.serverImage == null // loading my image
            ? Container(
                clipBehavior: Clip.hardEdge,
                width: largeIconSize,
                height: largeIconSize,
                padding: EdgeInsets.all(largePadding),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(
                    1000,
                  ),
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            // have an image
            : Container(
                clipBehavior: Clip.hardEdge,
                width: largeIconSize,
                height: largeIconSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    1000,
                  ),
                ),
                child: Image.memory(
                  widget.beaconServerModel.serverImage!,
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              );
  }
}
