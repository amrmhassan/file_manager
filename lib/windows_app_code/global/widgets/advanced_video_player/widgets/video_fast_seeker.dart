// ignore_for_file: prefer_const_constructors

import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/h_space.dart';
import 'package:explorer/helpers/responsive.dart';
import 'package:flutter/material.dart';

class VideoFastSeeker extends StatefulWidget {
  final bool shown;
  final bool backward;
  final VoidCallback toggleControllerOverLayViewed;
  final int actualAmount;

  const VideoFastSeeker({
    super.key,
    required this.shown,
    required this.toggleControllerOverLayViewed,
    required this.backward,
    required this.actualAmount,
  });

  @override
  State<VideoFastSeeker> createState() => _VideoFastSeekerState();
}

class _VideoFastSeekerState extends State<VideoFastSeeker> {
  double get seekerWidgetWidth => (Responsive.getWidth(context) - 100);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.backward ? -seekerWidgetWidth / 2 : null,
      right: widget.backward ? null : -seekerWidgetWidth / 2,
      child: Opacity(
        opacity: widget.shown ? 1 : 0,
        child: Container(
          alignment: Alignment.centerRight,
          width: seekerWidgetWidth,
          height: seekerWidgetWidth,
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
                '${widget.backward ? '-' : '+'}${widget.actualAmount} S',
                style: h3TextStyle,
              ),
              if (widget.backward) HSpace(factor: 2),
            ],
          ),
        ),
      ),
    );
  }
}
