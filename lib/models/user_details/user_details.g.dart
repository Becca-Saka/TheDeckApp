// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetails _$UserDetailsFromJson(Map json) => UserDetails(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as String?,
      email: json['email'] as String?,
      imageUrl: json['imageUrl'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      currentDeck: (json['currentDeck'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      prefferedGender: json['prefferedGender'] as String?,
      lastMatchedTime: json['lastMatchedTime'],
      currentMatches: (json['currentMatches'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fcmToken: json['fcmToken'] as String?,
      noOfCurrentMatches: json['noOfCurrentMatches'] as int? ?? 0,
      previousMatches: (json['previousMatches'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      imageList: (json['imageList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      openToMatch: json['openToMatch'] as bool? ?? false,
      recieveMatchNotification:
          json['recieveMatchNotification'] as bool? ?? true,
      recieveMessageNotification:
          json['recieveMessageNotification'] as bool? ?? true,
      long: (json['long'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserDetailsToJson(UserDetails instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'age': instance.age,
      'prefferedGender': instance.prefferedGender,
      'gender': instance.gender,
      'noOfCurrentMatches': instance.noOfCurrentMatches,
      'imageUrl': instance.imageUrl,
      'fcmToken': instance.fcmToken,
      'lat': instance.lat,
      'long': instance.long,
      'openToMatch': instance.openToMatch,
      'recieveMatchNotification': instance.recieveMatchNotification,
      'recieveMessageNotification': instance.recieveMessageNotification,
      'currentMatches': instance.currentMatches,
      'currentDeck': instance.currentDeck,
      'previousMatches': instance.previousMatches,
      'imageList': instance.imageList,
      'blockedUsers': instance.blockedUsers,
      'lastMatchedTime': instance.lastMatchedTime,
    };
