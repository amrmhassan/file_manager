// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:explorer/constants/sizes.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/global/widgets/v_space.dart';
import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VideoPositionViewer extends StatelessWidget {
  const VideoPositionViewer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = Provider.of<MediaPlayerProvider>(context);
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);
    DateTime startDate = DateTime(2000, 1, 1, 0, 0, 0);
    String fullDuration = DateFormat('HH:mm:ss')
        .format(startDate.add(mpProviderFalse.videoDuration ?? Duration.zero));
    String currentDuration = DateFormat('HH:mm:ss')
        .format(startDate.add(mpProviderFalse.videoPosition));

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
                    VSpace(factor: .5),
                    PaddingWrapper(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentDuration,
                            style: h4TextStyleInactive.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            fullDuration,
                            style: h4TextStyleInactive.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
