import 'package:explorer/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:localization/localization.dart';

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

  PermissionModel copy() {
    return PermissionModel(
      permissionName: permissionName,
      permissionStatus: permissionStatus,
    );
  }
}

// we have some kinds of permissions like the below permissions
@HiveType(typeId: 15)
enum PermissionName {
  @HiveField(0)
  beaconConnect,
  @HiveField(1)
  fileExploring,
  @HiveField(2)
  shareSpace,
  @HiveField(3)
  copyClipboard,
  @HiveField(4)
  sendFile,
  @HiveField(5)
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
  PermissionModel(
    permissionName: PermissionName.beaconConnect,
    permissionStatus: PermissionStatus.ask,
  ),
];

class PermissionsNamesUtils {
  static String getPermissionNameReadable(
    PermissionName permissionName,
    String peerName,
  ) {
    if (permissionName == PermissionName.fileExploring) {
      return '$peerName ${"file-exploring-ask".i18n()}';
    } else if (permissionName == PermissionName.shareSpace) {
      return '$peerName ${"share-space-ask".i18n()}';
    } else if (permissionName == PermissionName.copyClipboard) {
      return '$peerName ${"clipboard-ask".i18n()}';
    } else if (permissionName == PermissionName.sendFile) {
      return '$peerName ${"send-file-ask".i18n()}';
    } else if (permissionName == PermissionName.sendText) {
      return '$peerName ${"send-text-ask".i18n()}';
    } else if (permissionName == PermissionName.beaconConnect) {
      return '$peerName ${"connect-ask".i18n()}';
    } else {
      return '$peerName ${"unknown-permission-ask".i18n()} ${permissionName.name}';
    }
  }

  static String blockPermissionReadable(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return 'file-exploring-refuse'.i18n();
    } else if (permissionName == PermissionName.shareSpace) {
      return 'share-space-refuse'.i18n();
    } else if (permissionName == PermissionName.copyClipboard) {
      return 'copy-clipboard-refuse'.i18n();
    } else if (permissionName == PermissionName.sendFile) {
      return 'send-file-refuse'.i18n();
    } else if (permissionName == PermissionName.sendText) {
      return 'send-text-refuse'.i18n();
    } else if (permissionName == PermissionName.beaconConnect) {
      return 'connect-refuse'.i18n();
    } else {
      return '${"unknown-permission-refuse".i18n()} ${permissionName.name}';
    }
  }

  static String getPermissionTitle(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return "file-exploring".i18n();
    } else if (permissionName == PermissionName.shareSpace) {
      return "share-space".i18n();
    } else if (permissionName == PermissionName.copyClipboard) {
      return "clipboard".i18n();
    } else if (permissionName == PermissionName.sendFile) {
      return "send-file".i18n();
    } else if (permissionName == PermissionName.sendText) {
      return "send-text".i18n();
    } else if (permissionName == PermissionName.beaconConnect) {
      return "connect".i18n();
    } else {
      return permissionName.name.toUpperCase();
    }
  }

  static String getPermissionTitleMin(PermissionName permissionName) {
    if (permissionName == PermissionName.fileExploring) {
      return 'file-exploring'.i18n();
    } else if (permissionName == PermissionName.shareSpace) {
      return 'share-space'.i18n();
    } else if (permissionName == PermissionName.copyClipboard) {
      return 'clipboard'.i18n();
    } else if (permissionName == PermissionName.sendFile) {
      return 'send-file'.i18n();
    } else if (permissionName == PermissionName.sendText) {
      return 'send-text'.i18n();
    } else if (permissionName == PermissionName.beaconConnect) {
      return 'connect'.i18n();
    } else {
      return '${permissionName.name.toUpperCase()} ${"permission".i18n()}';
    }
  }

  static String getPermissionStatusTitle(PermissionStatus status) {
    if (status == PermissionStatus.allowed) {
      return 'allow'.i18n();
    } else if (status == PermissionStatus.blocked) {
      return 'block'.i18n();
    } else if (status == PermissionStatus.ask) {
      return 'ask'.i18n();
    } else {
      return '${status.name.toUpperCase()} ${"permission".i18n()}';
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
