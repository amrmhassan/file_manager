// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_permissions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeerPermissionsModelAdapter extends TypeAdapter<PeerPermissionsModel> {
  @override
  final int typeId = 13;

  @override
  PeerPermissionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeerPermissionsModel(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PeerPermissionsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.peerDeviceID)
      ..writeByte(1)
      ..write(obj.peerName)
      ..writeByte(2)
      ..write(obj._userPermissions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerPermissionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PermissionModelAdapter extends TypeAdapter<PermissionModel> {
  @override
  final int typeId = 14;

  @override
  PermissionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PermissionModel(
      permissionName: fields[0] as PermissionName,
      permissionStatus: fields[1] as PermissionStatus,
    );
  }

  @override
  void write(BinaryWriter writer, PermissionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.permissionName)
      ..writeByte(1)
      ..write(obj.permissionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PermissionNameAdapter extends TypeAdapter<PermissionName> {
  @override
  final int typeId = 15;

  @override
  PermissionName read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PermissionName.fileExploring;
      case 1:
        return PermissionName.shareSpace;
      case 2:
        return PermissionName.copyClipboard;
      case 3:
        return PermissionName.sendFile;
      case 4:
        return PermissionName.sendText;
      default:
        return PermissionName.fileExploring;
    }
  }

  @override
  void write(BinaryWriter writer, PermissionName obj) {
    switch (obj) {
      case PermissionName.fileExploring:
        writer.writeByte(0);
        break;
      case PermissionName.shareSpace:
        writer.writeByte(1);
        break;
      case PermissionName.copyClipboard:
        writer.writeByte(2);
        break;
      case PermissionName.sendFile:
        writer.writeByte(3);
        break;
      case PermissionName.sendText:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PermissionStatusAdapter extends TypeAdapter<PermissionStatus> {
  @override
  final int typeId = 16;

  @override
  PermissionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PermissionStatus.allowed;
      case 1:
        return PermissionStatus.blocked;
      case 2:
        return PermissionStatus.ask;
      default:
        return PermissionStatus.allowed;
    }
  }

  @override
  void write(BinaryWriter writer, PermissionStatus obj) {
    switch (obj) {
      case PermissionStatus.allowed:
        writer.writeByte(0);
        break;
      case PermissionStatus.blocked:
        writer.writeByte(1);
        break;
      case PermissionStatus.ask:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
