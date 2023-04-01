// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/button_wrapper.dart';
import 'package:explorer/global/widgets/h_line.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:explorer/providers/media_player_provider/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double height = 200;
const double width = 50;

class CustomVolumeControllers extends StatefulWidget {
  const CustomVolumeControllers({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVolumeControllers> createState() =>
      _CustomVolumeControllersState();
}

class _CustomVolumeControllersState extends State<CustomVolumeControllers> {
  // double? previousPosition;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<MediaPlayerProvider>(context, listen: false)
          .updateDeviceVolume();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return Positioned(
      right: -1,
      top: (Responsive.getHeight(context) - height) / 2,
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          border: Border.all(color: kInverseColor.withOpacity(.5)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(mediumBorderRadius),
            bottomLeft: Radius.circular(mediumBorderRadius),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: kCardBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(mediumBorderRadius),
                    ),
                  ),
                  child: FractionallySizedBox(
                    heightFactor: mpProvider.deviceVolume,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            HLine(
              color: Colors.white.withOpacity(.4),
            ),
            ButtonWrapper(
              borderRadius: 0,
              onTap: () {},
              padding: EdgeInsets.all(largePadding / 1.5),
              child: Image.asset(
                'assets/icons/volume-mute.png',
                color: kMainIconColor.withOpacity(.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
