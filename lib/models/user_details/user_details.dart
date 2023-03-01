import 'package:json_annotation/json_annotation.dart';

part 'user_details.g.dart';

@JsonSerializable(
  anyMap: true,
)
class UserDetails {
  String? uid;
  String? name;
  String? email;
  String? age;
  String? prefferedGender;
  String? gender;
  int noOfCurrentMatches;
  String? imageUrl, fcmToken;
  double? lat, long;
  bool openToMatch;
  bool recieveMatchNotification, recieveMessageNotification;
  List<String> currentMatches;
  List<String> currentDeck;
  List<String> previousMatches, imageList, blockedUsers;
  dynamic lastMatchedTime;
  UserDetails(
      {this.uid,
      this.name,
      this.gender,
      this.age,
      this.email,
      this.imageUrl,
      this.lat,
      this.currentDeck = const [],
      this.prefferedGender,
      this.lastMatchedTime,
      this.currentMatches = const [],
      this.fcmToken,
      this.noOfCurrentMatches = 0,
      this.previousMatches = const [],
      this.blockedUsers = const [],
      this.imageList = const [],
      this.openToMatch = false,
      this.recieveMatchNotification = true,
      this.recieveMessageNotification = true,
      this.long});
  factory UserDetails.fromJson(Map<dynamic, dynamic> json) =>
      _$UserDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$UserDetailsToJson(this);
  @override
  String toString() {
    return 'uid: $uid, name: $name, gender: $gender, age: $age, lat: $lat, long: $long, currentmatches: $currentMatches';
  }
}
