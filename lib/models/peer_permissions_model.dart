import 'package:explorer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'peer_permissions_model.g.dart';

@HiveType(typeId: 13)
class PeerPermissionsModel {
  @HiveField(0)
  final String peerDeviceID;
  @HiveField(1)
  final String peerName;
  @HiveField(2)
  final List<PermissionModel> userPermissions;

  PeerPermissionsModel(
    this.peerDeviceID,
    this.peerName,
    this.userPermissions,
  );

  PermissionStatus getPermissionStatus(PermissionName permissionName) {
    return userPermissions
        .firstWhere((element) => element.permissionName == permissionName)
        .permissionStatus;
  }

  void editPermission(
    PermissionName permissionName, {
    required PermissionStatus status,
  }) {
    int index = userPermissions
        .indexWhere((element) => element.permissionName == permissionName);
    PermissionModel permissionModel = userPermissions[index];
    permissionModel.permissionStatus = status;
    userPermissions[index] = permissionModel;
  }
}

@HiveType(typeId: 14)
class PermissionModel {
  @HiveField(0)
  final PermissionName permissionName;
  @HiveField(1)
  PermissionStatus permissionStatus;

  PermissionModel({
    required this.permissionName,
    required this.permissionStatus,
  });
}

// we have some kinds of permissions like the below permissions
@HiveType(typeId: 15)
enum PermissionName {
  @HiveField(0)
  fileExploring,
  @HiveField(1)
  shareSpace,
  @HiveField(2)
  copyClipboard,
  @HiveField(3)
  sendFile,
  @HiveField(4)
  sendText,
}

// each of the previous permissions has 3 status
@HiveType(typeId: 16)
enum PermissionStatus {
  @HiveField(0)
  allowed,
  @HiveField(1)
  ask,
  @HiveField(2)
  blocked,
}

List<PermissionModel> defaultPermissions = [
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

  static String getPermissionTitleMin(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return 'File Exploring';
    } else if (permissionName == PermissionName.shareSpace) {
      return 'Share Space';
    } else if (permissionName == PermissionName.copyClipboard) {
      return 'Clipboard';
    } else if (permissionName == PermissionName.sendFile) {
      return 'Send File';
    } else if (permissionName == PermissionName.sendText) {
      return 'Send Text';
    } else {
      return '${permissionName.name.toUpperCase()} permission';
    }
  }

  static String getPermissionStatusTitle(PermissionStatus status) {
    if (status == PermissionStatus.allowed) {
      return 'Allow';
    } else if (status == PermissionStatus.blocked) {
      return 'Block';
    } else if (status == PermissionStatus.ask) {
      return 'Ask';
    } else {
      return '${status.name.toUpperCase()} permission';
    }
  }

  static Color getPermissionStatusColor(PermissionStatus status) {
    if (status == PermissionStatus.allowed) {
      return kGreenColor;
    } else if (status == PermissionStatus.blocked) {
      return kDangerColor;
    } else if (status == PermissionStatus.ask) {
      return Colors.grey;
    } else {
      return Colors.transparent;
    }
  }
}
