import 'package:explorer/models/peer_model.dart';

enum ShareSpaceVScreenDataType {
  filesExploring,
  shareSpace,
  listyExploring,
  recentlyViewed,
}

class ShareSpaceVScreenData {
  final bool laptop;
  final PeerModel? peerModel;
  final ShareSpaceVScreenDataType dataType;

  const ShareSpaceVScreenData({
    required this.peerModel,
    required this.laptop,
    required this.dataType,
  });
}
