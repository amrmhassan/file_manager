import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/animation_provider.dart';
import '../providers/media_player_provider_windows.dart';
import '../providers/window_provider.dart';

class WindowSProviders {
  //? media player provider
  static MediaPlayerProviderWindows mpP(BuildContext context) {
    return Provider.of<MediaPlayerProviderWindows>(context);
  }

  static MediaPlayerProviderWindows mpPF(BuildContext context) {
    return Provider.of<MediaPlayerProviderWindows>(context, listen: false);
  }

  //? connect phone provider
  static WindowProvider winPF(BuildContext context) {
    return Provider.of<WindowProvider>(context, listen: false);
  }

  static WindowProvider winP(BuildContext context) {
    return Provider.of<WindowProvider>(context);
  }

  //? connect phone provider
  static AnimationProvider animationPF(BuildContext context) {
    return Provider.of<AnimationProvider>(context, listen: false);
  }

  static AnimationProvider animationP(BuildContext context) {
    return Provider.of<AnimationProvider>(context);
  }
}
