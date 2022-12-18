import 'package:explorer/providers/media_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoControllers extends StatelessWidget {
  const VideoControllers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mpProviderFalse =
        Provider.of<MediaPlayerProvider>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            mpProviderFalse.closeVideo();
          },
          child: Container(
            width: double.infinity,
            height: 50,
            color: Colors.red,
          ),
        )
      ],
    );
  }
}
