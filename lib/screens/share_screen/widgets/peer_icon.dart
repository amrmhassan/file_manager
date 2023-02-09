// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:explorer/constants/colors.dart';
import 'package:explorer/constants/sizes.dart';
import 'package:explorer/models/peer_model.dart';
import 'package:explorer/utils/client_utils.dart' as client_utils;
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class PeerIcon extends StatefulWidget {
  final bool large;
  final PeerModel peerModel;
  final bool offline;

  const PeerIcon({
    Key? key,
    this.large = false,
    required this.peerModel,
    this.offline = false,
  }) : super(key: key);

  @override
  State<PeerIcon> createState() => _PeerIconState();
}

class _PeerIconState extends State<PeerIcon> {
  bool me = false;

  Uint8List? peerImage;
  Widget? get loadedPeerImage => peerImage == null
      ? null
      : Image.memory(
          peerImage!,
          alignment: Alignment.topCenter,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );

  void getRemoteImage() async {
    var image = await client_utils.getPeerImage(widget.peerModel.connLink);
    setState(() {
      peerImage = image;
    });
  }

  String? get myImagePath => sharePF(context).myImagePath;

  Widget getViewedImage() {
    // if me the it might have an image or not
    // me with image
    // me without an image

    // if other user then
    // default without image
    // run get the image from the server if have data then setState for the image

    if (me && myImagePath == null) {
      return Image.asset(
        'assets/icons/user.png',
        color: kCardBackgroundColor.withOpacity(1),
      );
    } else if (me && myImagePath != null) {
      return Image.file(
        File(myImagePath!),
        alignment: Alignment.topCenter,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (!me) {
      return Image.asset(
        'assets/icons/user.png',
        color: kCardBackgroundColor.withOpacity(1),
      );
    }
    return SizedBox();
  }

  @override
  void initState() {
    super.initState();
    if (widget.offline) {
      me = true;
      return;
    }

    me = serverPF(context).me(sharePF(context)).deviceID ==
        widget.peerModel.deviceID;
    if (!me) {
      getRemoteImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ((myImagePath == null && me) || (peerImage == null && !me))
          ? EdgeInsets.all(largePadding * 1.5)
          : null,
      clipBehavior: Clip.hardEdge,
      width: widget.large ? largeIconSize * 3 : 60,
      height: widget.large ? largeIconSize * 3 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white.withOpacity(.2),
      ),
      child: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        child: loadedPeerImage ?? getViewedImage(),
      ),
    );
  }
}
