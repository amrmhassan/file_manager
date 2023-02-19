class LaptopMessageModel {
  final String id;
  final String msg;
  final DateTime at;
  bool viewed;

  LaptopMessageModel({
    required this.id,
    required this.msg,
    required this.at,
    this.viewed = false,
  });
}
