class MessageModel {
  final String id;
  final String msg;
  final String senderID;
  final String senderName;
  final DateTime at;
  bool viewed;

  MessageModel({
    required this.id,
    required this.msg,
    required this.senderID,
    required this.senderName,
    required this.at,
    this.viewed = false,
  });
}
