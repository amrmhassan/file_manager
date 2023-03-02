// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadTaskModelAdapter extends TypeAdapter<DownloadTaskModel> {
  @override
  final int typeId = 1;

  @override
  DownloadTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadTaskModel(
      remoteDeviceName: fields[4] as String,
      remoteDeviceID: fields[5] as String,
      id: fields[0] as String,
      remoteFilePath: fields[1] as String,
      addedAt: fields[3] as DateTime,
      size: fields[6] as int?,
      finishedAt: fields[7] as DateTime?,
      count: fields[9] as int,
      taskStatus: fields[8] as TaskStatus,
    )..localFilePath = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, DownloadTaskModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.remoteFilePath)
      ..writeByte(2)
      ..write(obj.localFilePath)
      ..writeByte(3)
      ..write(obj.addedAt)
      ..writeByte(4)
      ..write(obj.remoteDeviceName)
      ..writeByte(5)
      ..write(obj.remoteDeviceID)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.finishedAt)
      ..writeByte(8)
      ..write(obj.taskStatus)
      ..writeByte(9)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
