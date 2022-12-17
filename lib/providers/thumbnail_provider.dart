import 'package:flutter/cupertino.dart';

int maximumCompressingAtATime = 2;

class ThumbnailProvider extends ChangeNotifier {
  //? the currently compressing thumbnails
  int currentCompressing = 0;

  //? to increment the compressing thumbnails number
  void incrementCompressing() {
    currentCompressing++;
  }

  //? to decrement the compressing thumbnails number
  void decrementCompressing() {
    currentCompressing--;
  }

  //? to check if i am allowed to compress or not
  bool get allowMeToCompress {
    return currentCompressing <= maximumCompressingAtATime;
  }
}
