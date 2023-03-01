import 'package:json_annotation/json_annotation.dart';

part 'message_details.g.dart';

@JsonSerializable(
  anyMap: true,
)
class Message {
  String? type, message, senderId, imageUrl, uid;
  dynamic time;
  bool? isImage;
  Message(
      {this.uid,
      this.message,
      this.time,
      this.senderId,
      this.imageUrl,
      this.isImage});
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable(
  anyMap: true,
)
class ChatDetails {
  String? chatId, senderId;

  String? recieverId, recentmessage, recentMessageTime;
  List<Message>? messages;
  bool? isRead = false;
  ChatDetails({
    this.chatId,
    this.senderId,
    this.recentmessage,
    this.recieverId,
    this.recentMessageTime,
    this.isRead,
    this.messages,
  });
  factory ChatDetails.fromJson(Map<String, dynamic> json) =>
      _$ChatDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$ChatDetailsToJson(this);
}
