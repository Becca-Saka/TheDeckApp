import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:thedeck/models/message_details/message_details.dart';

part 'match_details.g.dart';

@JsonSerializable(
  anyMap: true,
)
class MatchDetails extends Equatable {
  final String? uid;
  final List<String> users;
  final Map<String, bool>? isNew;
  final String? messageId;
  final dynamic timeMatched;
  final List<String>? unReadMessagesList;
  final String? recentmessage;
  final dynamic recentMessageTime;

  @JsonKey(includeToJson: false)
  final List<Message>? messages;

  const MatchDetails(
      {this.uid,
      this.isNew,
      this.messageId,
      this.timeMatched,
      required this.users,
      this.messages,
      this.recentMessageTime,
      this.unReadMessagesList,
      this.recentmessage});

  factory MatchDetails.fromJson(Map<String, dynamic> json) =>
      _$MatchDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MatchDetailsToJson(this);

  @override
  String toString() {
    return 'uid: $uid';
  }

  @override
  List<Object> get props => [
        uid!,
        users,
        isNew!,
        messageId!,
        timeMatched!,
        messages!,
        recentMessageTime!,
        unReadMessagesList!,
        recentmessage!
      ];
}
