// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map json) => Message(
      uid: json['uid'] as String?,
      message: json['message'] as String?,
      time: json['time'],
      senderId: json['senderId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isImage: json['isImage'] as bool?,
    )..type = json['type'] as String?;

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'senderId': instance.senderId,
      'imageUrl': instance.imageUrl,
      'uid': instance.uid,
      'time': instance.time,
      'isImage': instance.isImage,
    };

ChatDetails _$ChatDetailsFromJson(Map json) => ChatDetails(
      chatId: json['chatId'] as String?,
      senderId: json['senderId'] as String?,
      recentmessage: json['recentmessage'] as String?,
      recieverId: json['recieverId'] as String?,
      recentMessageTime: json['recentMessageTime'] as String?,
      isRead: json['isRead'] as bool?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );

Map<String, dynamic> _$ChatDetailsToJson(ChatDetails instance) =>
    <String, dynamic>{
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'recieverId': instance.recieverId,
      'recentmessage': instance.recentmessage,
      'recentMessageTime': instance.recentMessageTime,
      'messages': instance.messages,
      'isRead': instance.isRead,
    };
