// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_client.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BeaconClientAdapter extends TypeAdapter<BeaconClient> {
  @override
  final int typeId = 17;

  @override
  BeaconClient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BeaconClient(
      userID: fields[0] as String,
      userName: fields[1] as String,
      permissionStatus: fields[2] as PermissionStatus,
    );
  }

  @override
  void write(BinaryWriter writer, BeaconClient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userID)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.permissionStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeaconClientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
