import 'package:dart_vlc/dart_vlc.dart';
import 'package:explorer/windows_app_code/utils/windows_provider_calls.dart';
import 'package:flutter/material.dart';

class ActualVideoPlayer extends StatelessWidget {
  const ActualVideoPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProvider = WindowSProviders.mpP(context);
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      width: double.infinity,
      // height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (mpProvider.videoPlayerController != null)
            Expanded(
              child: Video(
                showControls: false,
                player: mpProvider.videoPlayerController!,
              ),
            ),
        ],
      ),
    );
  }
}
