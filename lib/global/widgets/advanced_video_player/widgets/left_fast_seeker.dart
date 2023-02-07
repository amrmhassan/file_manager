// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/utils/providers_calls_utils.dart';
import 'package:flutter/material.dart';

class VideoFastSeeker extends StatefulWidget {
  final bool backward;
  final VoidCallback toggleControllerOverLayViewed;

  const VideoFastSeeker({
    super.key,
    required this.backward,
    required this.toggleControllerOverLayViewed,
  });

  @override
  State<VideoFastSeeker> createState() => _VideoFastSeekerState();
}

class _VideoFastSeekerState extends State<VideoFastSeeker> {
  bool shown = false;
  int amount = 0;
  int actualAmount = 0;

  void backward() {
    if (widget.backward) {
      mpPF(context).videoBackWard10();
    } else {
      mpPF(context).videoForWard10();
    }
    setState(() {
      amount += 10;
      actualAmount += 10;
      shown = true;
    });

    Future.delayed(Duration(milliseconds: 600)).then((value) {
      amount -= 10;
      setState(() {
        if (amount == 0) {
          actualAmount = 0;
          shown = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.backward ? -150 : null,
      right: widget.backward ? null : -150,
      child: GestureDetector(
        onDoubleTap: backward,
        onTap: widget.toggleControllerOverLayViewed,
        child: Opacity(
          opacity: shown ? 1 : 0,
          child: Container(
            alignment: Alignment.centerRight,
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Row(
              mainAxisAlignment: widget.backward
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (!widget.backward) HSpace(factor: 2),
                Text(
                  '${widget.backward ? '-' : '+'}$actualAmount S',
                  style: h3TextStyle,
                ),
                if (widget.backward) HSpace(factor: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
