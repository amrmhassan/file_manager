import 'package:explorer/helpers/hive/hive_helper.dart';
import 'package:explorer/models/peer_permissions_model.dart';
import 'package:flutter/foundation.dart';

class PermissionProvider extends ChangeNotifier {
  // i will need to load these permissions after each new group connection or anything that is related to connecting to devices, either with laptop or any other thing
  // actually i will need to load the permission once the app starts
  // the status.ask option will control if i want to allow the device only one time or for every time
  // so if status.ask is false i won't save the option to any of these(hive or provider)
  // if true i will save it for provider and hive to load it later in the app startup
  // if status.ask is false i will only apply it for this time, and this will be handled from the middleware, not from here

  List<PeerPermissionsModel> _peersPermissions = [];
  List<PeerPermissionsModel> get peersPermissions =>
      [..._peersPermissions.reversed];

  Future<void> loadPeersPermissions() async {
    var box = await HiveBox.peerPermissionsBox;

    _peersPermissions = [...box.values.toList().cast()];
    // if (kDebugMode) {
    //   _peersPermissions.add(
    //     PeerPermissionsModel(
    //       'peerDeviceID',
    //       'peerName',
    //       defaultPermissions,
    //     ),
    //   );
    // }
    notifyListeners();
  }

  void _addPeerPermission({
    required String peerDeviceID,
    required String peerName,
  }) {
    var defaultPermissionsCopy = defaultPermissions.map(
      (e) => e.copy(),
    );
    PeerPermissionsModel newPeerPermissions = PeerPermissionsModel(
      peerDeviceID,
      peerName,
      [...defaultPermissionsCopy],
    );
    _peersPermissions.add(newPeerPermissions);
  }

  Future<void> editPeerPermission(
    String peerDeviceID, {
    required PermissionName permissionName,
    required PermissionStatus status,
    required String peerName,
  }) async {
    bool added = _peerAdded(peerDeviceID);
    if (!added) {
      _addPeerPermission(peerDeviceID: peerDeviceID, peerName: peerName);
    }
    //? this will return if the remember is not true, cause this will be, actually i don't need that remember thing, because i have the permissions status(allow, ignore, ask )
    // if (status == PermissionStatus.ask) return;
    int index = _peersPermissions
        .indexWhere((element) => element.peerDeviceID == peerDeviceID);
    PeerPermissionsModel model = _peersPermissions[index];
    model.editPermission(
      permissionName,
      status: status,
    );
    _peersPermissions[index] = model;
    notifyListeners();

    // here i will just save the peer permission because i want to it will be the default
    var box = await HiveBox.peerPermissionsBox;
    await box.put(peerDeviceID, model);
  }

  PermissionStatus getPermissionStatus(
    String userDeviceID, {
    required PermissionName permissionName,
    required String userName,
  }) {
    bool added = _peerAdded(userDeviceID);
    if (!added) {
      editPeerPermission(
        userDeviceID,
        permissionName: permissionName,
        status: defaultPermissions
            .firstWhere((element) => element.permissionName == permissionName)
            .permissionStatus,
        peerName: userName,
      );
      // if the user does'nt exist i will ask the user to allow him or not
      // this will be done be returning ask
      return defaultPermissions
          .firstWhere((element) => element.permissionName == permissionName)
          .permissionStatus;
    }
    return _peersPermissions
        .firstWhere((element) => element.peerDeviceID == userDeviceID)
        .getPermissionStatus(permissionName);
  }

  // this is to check if the peer is added once at least or not
  bool _peerAdded(String userID) {
    return _peersPermissions.any((element) => element.peerDeviceID == userID);
  }

  Future<void> deleteAllUserPermissions(String userID) async {
    _peersPermissions.removeWhere((element) => element.peerDeviceID == userID);
    notifyListeners();
    var box = await HiveBox.peerPermissionsBox;
    await box.delete(userID);
  }

  PeerPermissionsModel peerPermissionsModelFromId(String userID) {
    return _peersPermissions
        .firstWhere((element) => element.peerDeviceID == userID);
  }

  Future<void> allowAllForAUser(String userID, String userName) async {
    for (var element in defaultPermissions) {
      await editPeerPermission(
        userID,
        permissionName: element.permissionName,
        status: PermissionStatus.allowed,
        peerName: userName,
      );
    }
  }

  Future<void> blockAllForAUser(String userID, String userName) async {
    for (var element in defaultPermissions) {
      await editPeerPermission(
        userID,
        permissionName: element.permissionName,
        status: PermissionStatus.blocked,
        peerName: userName,
      );
    }
  }

  Future<void> askAllForAUser(String userID, String userName) async {
    for (var element in defaultPermissions) {
      await editPeerPermission(
        userID,
        permissionName: element.permissionName,
        status: PermissionStatus.ask,
        peerName: userName,
      );
    }
  }
}
