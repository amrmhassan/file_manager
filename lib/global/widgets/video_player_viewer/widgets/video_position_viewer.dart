// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoPositionViewer extends StatelessWidget {
  const VideoPositionViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);

    return mpProvider.seekerTouched
        ? Column(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    PaddingWrapper(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.hardEdge,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(
                            mediumBorderRadius,
                          ),
                        ),
                        child: FractionallySizedBox(
                          widthFactor: (mpProvider
                                          .videoPosition.inMilliseconds /
                                      (mpProvider
                                              .videoDuration?.inMilliseconds ??
                                          1)) <
                                  0
                              ? 0
                              : (mpProvider.videoPosition.inMilliseconds /
                                  (mpProvider.videoDuration?.inMilliseconds ??
                                      1)),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
