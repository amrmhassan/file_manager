class PeerPermissionsModel {
  final String peerDeviceID;
  final String peerName;
  final List<PermissionModel> _userPermissions = _defaultPermissions;

  PeerPermissionsModel(
    this.peerDeviceID,
    this.peerName,
  );

  PermissionStatus getPermissionStatus(PermissionName permissionName) {
    return _userPermissions
        .firstWhere((element) => element.permissionName == permissionName)
        .permissionStatus;
  }

  void editPermission(
    PermissionName permissionName, {
    required PermissionStatus status,
  }) {
    int index = _userPermissions
        .indexWhere((element) => element.permissionName == permissionName);
    PermissionModel permissionModel = _userPermissions[index];
    permissionModel.permissionStatus = status;
    _userPermissions[index] = permissionModel;
  }
}

class PermissionModel {
  final PermissionName permissionName;
  PermissionStatus permissionStatus;

  PermissionModel({
    required this.permissionName,
    required this.permissionStatus,
  });
}

// we have some kinds of permissions like the below permissions
enum PermissionName {
  fileExploring,
  shareSpace,
  copyClipboard,
  sendFile,
  sendText,
}

// each of the previous permissions has 3 status
enum PermissionStatus {
  allowed,
  blocked,
  ask,
}

List<PermissionModel> _defaultPermissions = [
  PermissionModel(
    permissionName: PermissionName.fileExploring,
    permissionStatus: PermissionStatus.ask,
  ),
  PermissionModel(
    permissionName: PermissionName.shareSpace,
    permissionStatus: PermissionStatus.ask,
  ),
  PermissionModel(
    permissionName: PermissionName.copyClipboard,
    permissionStatus: PermissionStatus.ask,
  ),
  PermissionModel(
    permissionName: PermissionName.sendFile,
    permissionStatus: PermissionStatus.ask,
  ),
  PermissionModel(
    permissionName: PermissionName.sendText,
    permissionStatus: PermissionStatus.allowed,
  ),
];

class PermissionsNamesUtils {
  static String getPermissionNameReadable(
    PermissionName permissionName,
    String peerName,
  ) {
    if (permissionName == PermissionName.fileExploring) {
      return '$peerName wants to explore your files';
    } else if (permissionName == PermissionName.shareSpace) {
      return '$peerName wants to access your share space';
    } else if (permissionName == PermissionName.copyClipboard) {
      return '$peerName wants to copy your clipboard';
    } else if (permissionName == PermissionName.sendFile) {
      return '$peerName wants to send you a file';
    } else if (permissionName == PermissionName.sendText) {
      return '$peerName wants to send you a text';
    } else {
      return '$peerName wants to do this permission ${permissionName.name}';
    }
  }

  static String blockPermissionReadable(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return 'you can\'t explore this user files';
    } else if (permissionName == PermissionName.shareSpace) {
      return 'you can\'t access this user share space';
    } else if (permissionName == PermissionName.copyClipboard) {
      return 'you can\'t copy this user clipboard';
    } else if (permissionName == PermissionName.sendFile) {
      return 'you can\'t send this user a file';
    } else if (permissionName == PermissionName.sendText) {
      return 'you can\'t send this user a text';
    } else {
      return 'you can\'t do this permission ${permissionName.name}';
    }
  }

  static String getPermissionTitle(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return 'File Exploring permission';
    } else if (permissionName == PermissionName.shareSpace) {
      return 'Share Space permission';
    } else if (permissionName == PermissionName.copyClipboard) {
      return 'Clipboard Permission';
    } else if (permissionName == PermissionName.sendFile) {
      return 'Send File permission';
    } else if (permissionName == PermissionName.sendText) {
      return 'Send Text permission';
    } else {
      return '${permissionName.name.toUpperCase()} permission';
    }
  }
}
