//? end points

//? this is the endpoints of server 1(the share space server of phones)
class EndPoints {
// other
  static const String dummy = '/dummyendpointjustlikethemainone';

// files
  static const String getShareSpace = '/getShareSpace';
  static const String fileAddedToShareSpace = '/fileAddedToShareSpace';
  static const String fileRemovedFromShareSpace = '/fileRemovedFromShareSpace';
  static const String getFolderContentEndPoint = '/getFolderContentEndPoint';
  static const String streamAudio = '/streamAudio';
  static const String streamVideo = '/streamVideo';
  static const String downloadFile = '/downloadFile';
  static const String wsServerConnLink = '/wsServerConnLink';
  static const String phoneWsServerConnLink = '/phoneWsServerConnLink';

// clients
  static const String addClient = '/addClient';
  static const String clientAdded = '/clientAdded';
  static const String clientLeft = '/clientLeft';
  static const String getPeerImagePath = '/getPeerImagePath';

// server checking
  static const String serverCheck = '/serverCheckEndPoint';
  static const String getDiskNames = '/getDiskNamesEndPoint';

// connect laptop endpoints
  static const String getStorage = '/getStorage';
  static const String getPhoneFolderContent = '/getPhoneFolderContentEndPoint';
  static const String areYouAlive = '/areYouAliveEndPoint';
  static const String getClipboard = '/getClipboardEndPoint';
  static const String sendText = '/sendTextEndpoint';
  static const String getListy = '/getListyEndPoint';
  static const String startDownloadFile = '/startDownloadFileEndPoint';
  static const String getFullFolderContent =
      '/getFolderContentRecursiveEndPoint';
  static const String getLaptopDeviceID = '/getLaptopDeviceIDEndPoint';
  static const String getLaptopDeviceName = '/getLaptopDeviceNameEndpoint';
  static const String getAndroidName = '/getAndroidNameEndPoint';
  static const String getAndroidID = '/getAndroidIDEndPoint';
}

//? headers keys
class KHeaders {
  static const String folderPathHeaderKey = 'folderPathHeaderKey';
  static const String sessionIDHeaderKey = 'sessionIDHeaderKey';
  static const String filePathHeaderKey = 'filePathHeaderKey';
  static const String reqIntentPathHeaderKey = 'reqIntentPathHeaderKey';
  static const String deviceIDHeaderKey = 'deviceIDHeaderKey';
  static const String userNameHeaderKey = 'userNameHeaderKey';
  static const String serverRefuseReasonHeaderKey =
      'serverRefuseReasonHeaderKey';
  static const String myConnLinkHeaderKey = 'myConnLinkHeaderKey';

// connect laptop headers
  static const String freeSpaceHeaderKey = 'freeSpaceHeaderKey';
  static const String totalSpaceHeaderKey = 'totalSpaceHeaderKey';
  static const String parentFolderPathHeaderKey = 'parentFolderPathHeaderKey';
  static const String myServerPortHeaderKey = 'myServerPortHeaderKey';
  static const String fileSizeHeaderKey = 'fileSizeHeaderKey';
}

class SocketPaths {
//? socket server paths
  static const String moveCursorPath = 'moveCursorPath';
  static const String mouseRightClickedPath = 'mouseRightClickedPath';
  static const String mouseLeftClickedPath = 'mouseLeftClickedPath';
  static const String mouseLeftDownPath = 'mouseLeftDownPath';
  static const String mouseLeftUpPath = 'mouseLeftUpPath';
  static const String mouseEventClickDrag = 'mouseEventClickDrag';
}
