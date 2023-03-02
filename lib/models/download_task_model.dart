import 'package:explorer/constants/files_types_icons.dart';
import 'package:explorer/utils/download_utils/download_task_controller.dart';
import 'package:explorer/utils/files_operations_utils/download_utils.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path_operations;

part 'download_task_model.g.dart';
//? these tasks will be saved into the sqlite for later download
//? downloading might be continued in another session so i provided peer model which wont be saved to sqlite
//? but peer device id will be saved
//? so if peer model is null then this task is being continued in another session

enum TaskStatus {
  pending,
  paused,
  downloading,
  finished,
  failed,
}

@HiveType(typeId: 1)
class DownloadTaskModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String remoteFilePath;
  @HiveField(2)
  late String localFilePath;
  @HiveField(3)
  final DateTime addedAt;
  @HiveField(4)
  final String remoteDeviceName;
  @HiveField(5)
  final String remoteDeviceID;
  @HiveField(6)
  final int? size;
  DownloadTaskController? downloadTaskController;

  @HiveField(7)
  DateTime? finishedAt;
  @HiveField(8)
  TaskStatus taskStatus;
  @HiveField(9)
  int count;

  DownloadTaskModel({
    required this.remoteDeviceName,
    required this.remoteDeviceID,
    required this.id,
    required this.remoteFilePath,
    required this.addedAt,
    required this.size,
    this.downloadTaskController,
    this.finishedAt,
    this.count = 0,
    this.taskStatus = TaskStatus.pending,
    // this.peerModel,
  }) {
    String fileName = path_operations.basename(remoteFilePath);
    FileType fileType = getFileTypeFromPath(remoteFilePath);
    localFilePath = getSaveFilePath(fileType, fileName);
  }

  //! to json
  // Map<String, String> toJSON() {
  //   return {
  //     remoteDeviceIDString: remoteDeviceID,
  //     remoteDeviceNameString: remoteDeviceName,
  //     idString: id,
  //     remoteFilePathString: remoteFilePath,
  //     addedAtString: addedAt.toIso8601String(),
  //     sizeString: size == null ? dbNull : size.toString(),
  //     countString: count.toString(),
  //     taskStatusString: taskStatus.name,
  //     finishedAtString:
  //         finishedAt == null ? dbNull : finishedAt!.toIso8601String(),
  //   };
  // }
  // //! from json

  // static DownloadTaskModel fromJSON(Map<String, dynamic> obj) {
  //   return DownloadTaskModel(
  //     remoteDeviceID: obj[remoteDeviceIDString],
  //     remoteDeviceName: obj[remoteDeviceNameString],
  //     id: obj[idString],
  //     remoteFilePath: obj[remoteFilePathString],
  //     addedAt: DateTime.parse(obj[addedAtString]),
  //     size: obj[sizeString] == dbNull ? null : int.parse(obj[sizeString]),
  //     count: int.parse(obj[countString]),
  //     taskStatus: stringToEnum(obj[taskStatusString], TaskStatus.values),
  //     finishedAt: obj[finishedAtString] == dbNull
  //         ? null
  //         : DateTime.parse(obj[finishedAtString]),
  //   );
  // }
}
