//? end points

//? this is the endpoints of server 1(the share space server of phones)
class EndPoints1 {
// other
  static const String dummyEndPoint = '/dummyendpointjustlikethemainone';

// files
  static const String getShareSpaceEndPoint = '/getShareSpace';
  static const String fileAddedToShareSpaceEndPoint = '/fileAddedToShareSpace';
  static const String fileRemovedFromShareSpaceEndPoint =
      '/fileRemovedFromShareSpace';
  static const String getFolderContentEndPointEndPoint =
      '/getFolderContentEndPoint';
  static const String streamAudioEndPoint = '/streamAudio';
  static const String streamVideoEndPoint = '/streamVideo';
  static const String downloadFileEndPoint = '/downloadFile';
  static const String wsServerConnLinkEndPoint = '/wsServerConnLink';
  static const String phoneWsServerConnLinkEndPoint = '/phoneWsServerConnLink';

// clients
  static const String addClientEndPoint = '/addClient';
  static const String clientAddedEndPoint = '/clientAdded';
  static const String clientLeftEndPoint = '/clientLeft';
  static const String getPeerImagePathEndPoint = '/getPeerImagePath';

// server checking
  static const String serverCheckEndPoint = '/serverCheckEndPoint';
  static const String getDiskNamesEndPoint = '/getDiskNamesEndPoint';

// connect laptop endpoints
  static const String getStorageEndPoint = '/getStorage';
  static const String getPhoneFolderContentEndPoint =
      '/getPhoneFolderContentEndPoint';
  static const String areYouAliveEndPoint = '/areYouAliveEndPoint';
  static const String getClipboardEndPoint = '/getClipboardEndPoint';
  static const String sendTextEndpoint = '/sendTextEndpoint';
  static const String getListyEndPoint = '/getListyEndPoint';
  static const String startDownloadFileEndPoint = '/startDownloadFileEndPoint';
  static const String getFolderContentRecursiveEndPoint =
      '/getFolderContentRecursiveEndPoint';
  static const String getLaptopDeviceIDEndPoint = '/getLaptopDeviceIDEndPoint';
  static const String getLaptopDeviceNameEndpoint =
      '/getLaptopDeviceNameEndpoint';
  static const String getAndroidNameEndPoint = '/getAndroidNameEndPoint';
  static const String getAndroidIDEndPoint = '/getAndroidIDEndPoint';
}

//? headers keys
const String folderPathHeaderKey = 'folderPathHeaderKey';
const String sessionIDHeaderKey = 'sessionIDHeaderKey';
const String filePathHeaderKey = 'filePathHeaderKey';
const String reqIntentPathHeaderKey = 'reqIntentPathHeaderKey';
const String deviceIDHeaderKey = 'deviceIDHeaderKey';
const String userNameHeaderKey = 'userNameHeaderKey';
const String serverRefuseReasonHeaderKey = 'serverRefuseReasonHeaderKey';
const String myConnLinkHeaderKey = 'myConnLinkHeaderKey';

// connect laptop headers
const String freeSpaceHeaderKey = 'freeSpaceHeaderKey';
const String totalSpaceHeaderKey = 'totalSpaceHeaderKey';
const String parentFolderPathHeaderKey = 'parentFolderPathHeaderKey';
const String myServerPortHeaderKey = 'myServerPortHeaderKey';
const String fileSizeHeaderKey = 'fileSizeHeaderKey';

//? socket server paths
const String moveCursorPath = 'moveCursorPath';
const String mouseRightClickedPath = 'mouseRightClickedPath';
const String mouseLeftClickedPath = 'mouseLeftClickedPath';
const String mouseLeftDownPath = 'mouseLeftDownPath';
const String mouseLeftUpPath = 'mouseLeftUpPath';
const String mouseEventClickDrag = 'mouseEventClickDrag';
