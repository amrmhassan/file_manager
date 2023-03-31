import 'package:flutter/material.dart';
import 'package:explorer/constants/styles.dart';
import 'package:explorer/global/widgets/padding_wrapper.dart';
import 'package:explorer/utils/duration_utils.dart';

import '../../../../utils/windows_provider_calls.dart';

class VideoDurationViewer extends StatelessWidget {
  const VideoDurationViewer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);

    return PaddingWrapper(
      child: Row(
        children: [
          Text(
            '${durationToString(mpProvider.videoPosition)} / ${durationToString(mpProvider.videoDuration)}',
            style: h5TextStyle.copyWith(
              color: Colors.white.withOpacity(.8),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
